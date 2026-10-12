"""Configuration: the hosted default, the overrides, and what must never leak."""

import unittest

from fauxshield import (
    DEFAULT_BASE_URL,
    FauxShieldClient,
    FauxShieldConfigError,
    redact,
    resolve_config,
)
from fauxshield.config import resolve_base_url, validate_base_url

LOCAL = "http://localhost:8080"


class GivenTheBaseUrlRules(unittest.TestCase):
    def test_the_default_is_the_hosted_api_not_localhost(self):
        self.assertEqual(DEFAULT_BASE_URL, "https://fauxshield.api.serverpod.space")
        self.assertNotIn("localhost", DEFAULT_BASE_URL)
        self.assertTrue(DEFAULT_BASE_URL.startswith("https://"))

    def test_no_configuration_at_all_still_talks_to_the_hosted_api(self):
        config = resolve_config(environment={})
        self.assertEqual(config.base_url, DEFAULT_BASE_URL)

    def test_an_explicit_url_beats_the_environment(self):
        self.assertEqual(
            resolve_base_url(LOCAL, {"FAUXSHIELD_URL": "https://staging.test"}),
            LOCAL,
        )

    def test_the_environment_is_used_when_nothing_is_passed(self):
        self.assertEqual(
            resolve_base_url(None, {"FAUXSHIELD_URL": "https://staging.test"}),
            "https://staging.test",
        )

    def test_a_local_server_is_one_argument_away(self):
        client = FauxShieldClient(api_key="fs_live_x", base_url=LOCAL)
        self.assertEqual(client.base_url, LOCAL)

    def test_a_trailing_slash_is_normalised_away(self):
        self.assertEqual(validate_base_url("https://example.test/"), "https://example.test")

    def test_a_url_that_is_not_http_is_refused_with_advice(self):
        with self.assertRaises(FauxShieldConfigError) as raised:
            validate_base_url("fauxshield.api.serverpod.space")
        self.assertIn("https", str(raised.exception))
        self.assertIn(DEFAULT_BASE_URL, str(raised.exception))

    def test_a_query_string_is_refused(self):
        with self.assertRaises(FauxShieldConfigError):
            validate_base_url("https://example.test?a=1")

    def test_the_resolved_config_carries_the_timeout_and_retries(self):
        config = resolve_config(timeout=5, max_retries=0, environment={})
        self.assertEqual(config.timeout, 5.0)
        self.assertEqual(config.max_retries, 0)

    def test_a_nonsensical_timeout_is_refused(self):
        with self.assertRaises(FauxShieldConfigError):
            resolve_config(timeout=0, environment={})

    def test_negative_retries_are_refused(self):
        with self.assertRaises(FauxShieldConfigError):
            resolve_config(max_retries=-1, environment={})


class GivenSecrets(unittest.TestCase):
    def test_a_key_prefix_is_masked(self):
        self.assertEqual(redact("fs_live_abc123"), "fs_live_…")

    def test_a_bearer_token_is_masked(self):
        token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.abcdefghijklmnop"
        self.assertNotIn(token, redact("Authorization: Bearer {}".format(token)))

    def test_the_key_is_read_from_the_environment_or_the_argument(self):
        from_environment = resolve_config(environment={"FAUXSHIELD_API_KEY": "fs_live_env"})
        self.assertEqual(from_environment.api_key, "fs_live_env")
        explicit = resolve_config(api_key="fs_live_arg", environment={"FAUXSHIELD_API_KEY": "fs_live_env"})
        self.assertEqual(explicit.api_key, "fs_live_arg")

    def test_a_config_error_never_contains_the_key(self):
        with self.assertRaises(FauxShieldConfigError) as raised:
            validate_base_url("fs_live_secret@example.test")
        self.assertNotIn("fs_live_secret", str(raised.exception))


if __name__ == "__main__":
    unittest.main()
