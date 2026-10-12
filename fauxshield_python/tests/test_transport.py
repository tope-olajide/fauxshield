"""The transport: what goes on the wire, and what comes back as an error."""

import json
import unittest
import urllib.error

from fauxshield import (
    ApiError,
    AuthenticationError,
    ConnectionError,
    FauxShieldClient,
    HttpTransport,
    NotFoundError,
    RateLimitError,
    ServiceUnavailableError,
    TimeoutError,
    ValidationError,
    VerificationError,
    is_retryable,
    resolve_config,
)

HOSTED = "https://fauxshield.api.serverpod.space"


class Recorder:
    """An opener that answers from a script and keeps the requests it saw."""

    def __init__(self, *answers):
        self.answers = list(answers)
        self.requests = []

    def __call__(self, url, payload, headers, timeout):
        self.requests.append({"url": url, "payload": payload, "headers": headers, "timeout": timeout})
        answer = self.answers.pop(0) if len(self.answers) > 1 else self.answers[0]
        if isinstance(answer, Exception):
            raise answer
        return answer


def transport(*answers, **config):
    settings = dict(api_key="fs_live_test", environment={})
    settings.update(config)
    recorder = Recorder(*answers)
    return HttpTransport(resolve_config(**settings), opener=recorder), recorder


class GivenAWorkingCall(unittest.TestCase):
    def test_a_call_posts_the_arguments_as_json_to_the_endpoint_method(self):
        http, recorder = transport((200, ""))
        http.call("product", "list", {"includeArchived": False, "search": None})

        request = recorder.requests[0]
        self.assertEqual(request["url"], "{}/product/list".format(HOSTED))
        self.assertEqual(json.loads(request["payload"]), {"includeArchived": False, "search": None})
        self.assertEqual(request["headers"]["content-type"], "application/json")
        self.assertEqual(request["headers"]["authorization"], "Bearer fs_live_test")

    def test_an_empty_success_body_is_none_not_an_error(self):
        http, _ = transport((200, ""))
        self.assertIsNone(http.call("batch", "delete", {}))

    def test_a_json_body_comes_back_parsed(self):
        http, _ = transport((200, '{"name":"Coffee","sku":"C-1"}'))
        self.assertEqual(http.call("product", "get", {})["name"], "Coffee")

    def test_a_local_base_url_is_used_when_one_is_configured(self):
        http, recorder = transport((200, ""), base_url="http://localhost:8080")
        http.call("product", "list", {})
        self.assertTrue(recorder.requests[0]["url"].startswith("http://localhost:8080/"))

    def test_a_call_without_a_key_sends_no_authorization_header(self):
        http, recorder = transport((200, ""), api_key=None)
        http.call("product", "list", {})
        self.assertNotIn("authorization", recorder.requests[0]["headers"])


class GivenAFailedCall(unittest.TestCase):
    def test_a_typed_server_exception_keeps_its_kind(self):
        body = json.dumps({"className": "ValidationException", "message": "name is required"})
        http, _ = transport((400, body))
        with self.assertRaises(ValidationError) as raised:
            http.call("product", "create", {})
        self.assertEqual(raised.exception.status, 400)
        self.assertIn("name is required", str(raised.exception))

    def test_the_body_the_api_actually_sends_is_understood(self):
        # Verified against the hosted API: a typed failure is HTTP 400 with the
        # exception nested under `data`.
        body = json.dumps(
            {
                "className": "NotFoundException",
                "data": {
                    "__className__": "NotFoundException",
                    "message": "No product with that id.",
                    "code": "api_error",
                    "resource": "product",
                },
            }
        )
        http, _ = transport((400, body), max_retries=0)
        with self.assertRaises(NotFoundError) as raised:
            http.call("product", "get", {})
        self.assertEqual(raised.exception.status, 400)
        self.assertEqual(str(raised.exception), "No product with that id.")
        self.assertFalse(is_retryable(raised.exception))

    def test_the_framework_s_own_401_is_authentication(self):
        http, _ = transport((401, ""), max_retries=0)
        with self.assertRaises(AuthenticationError):
            http.call("product", "list", {})

    def test_a_rate_limit_carries_its_delay_from_the_body(self):
        body = json.dumps(
            {
                "className": "RateLimitException",
                "data": {"message": "Too many requests.", "retryAfterSeconds": 42},
            }
        )
        http, _ = transport((400, body), max_retries=0)
        with self.assertRaises(RateLimitError) as raised:
            http.call("product", "list", {})
        self.assertEqual(raised.exception.retry_after, 42.0)
        self.assertTrue(is_retryable(raised.exception))

    def test_a_verification_refusal_is_its_own_error(self):
        body = json.dumps({"className": "VerificationException", "message": "Wrong PIN."})
        http, _ = transport((400, body))
        with self.assertRaises(VerificationError):
            http.call("verification", "submitPin", {})

    def test_a_bare_status_maps_to_the_error_a_caller_acts_on(self):
        http, _ = transport((429, ""), max_retries=0)
        with self.assertRaises(RateLimitError):
            http.call("alert", "list", {})

    def test_an_unmapped_status_is_an_api_error(self):
        http, _ = transport((500, "boom"), max_retries=0)
        with self.assertRaises(ApiError):
            http.call("alert", "list", {})

    def test_a_retry_after_header_is_honoured_over_the_backoff(self):
        http, _ = transport((429, "{}"), max_retries=0)
        self.assertEqual(http._delay(0, ApiError("wait", status=429)), 0.2)
        self.assertEqual(http._delay(0, ApiError("wait", status=429, retry_after=5)), 5.0)

    def test_a_socket_failure_is_a_connection_error_that_hides_the_key(self):
        failure = urllib.error.URLError("getaddrinfo failed")
        http, _ = transport(failure)
        with self.assertRaises(ConnectionError) as raised:
            http.call("product", "list", {})
        self.assertNotIn("fs_live_test", str(raised.exception))

    def test_a_url_error_that_wraps_a_socket_timeout_is_a_timeout(self):
        import socket

        failure = urllib.error.URLError(socket.timeout("timed out"))
        http, _ = transport(failure)
        with self.assertRaises(TimeoutError):
            http.call("product", "list", {})


class GivenRetries(unittest.TestCase):
    def test_a_transient_failure_is_retried_and_a_later_success_returned(self):
        http, recorder = transport((503, ""), (200, '{"ok":true}'))
        self.assertEqual(http.call("analytics", "dashboard", {}), {"ok": True})
        self.assertEqual(len(recorder.requests), 2)

    def test_retries_stop_at_max_retries(self):
        http, recorder = transport((503, ""))
        with self.assertRaises(ServiceUnavailableError):
            http.call("analytics", "dashboard", {})
        self.assertEqual(len(recorder.requests), 3)

    def test_retries_can_be_turned_off(self):
        http, recorder = transport((503, ""), max_retries=0)
        with self.assertRaises(ServiceUnavailableError):
            http.call("analytics", "dashboard", {})
        self.assertEqual(len(recorder.requests), 1)

    def test_a_validation_error_is_never_retried(self):
        body = json.dumps({"className": "ValidationException", "message": "name is required"})
        http, recorder = transport((400, body))
        with self.assertRaises(ValidationError):
            http.call("product", "create", {})
        self.assertEqual(len(recorder.requests), 1)


class GivenATextBody(unittest.TestCase):
    def test_plain_text_still_becomes_a_message(self):
        http, _ = transport((502, "Bad gateway"), max_retries=0)
        with self.assertRaises(ServiceUnavailableError) as raised:
            http.call("product", "list", {})
        self.assertIn("Bad gateway", str(raised.exception))


class GivenAClient(unittest.TestCase):
    def test_the_default_environment_needs_no_url(self):
        client = FauxShieldClient(api_key="fs_live_x", environment={})
        self.assertEqual(client.base_url, HOSTED)

    def test_every_endpoint_has_a_resource(self):
        client = FauxShieldClient(api_key="fs_live_x", environment={})
        for name in (
            "alert",
            "analytics",
            "api_key",
            "audit",
            "batch",
            "demo",
            "identity",
            "notification",
            "offline",
            "product",
            "recall",
            "simulation",
            "verification",
            "webhook_admin",
            "workspace",
        ):
            self.assertTrue(hasattr(client, name), "missing resource: {}".format(name))


if __name__ == "__main__":
    unittest.main()
