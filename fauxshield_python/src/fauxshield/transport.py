"""The transport: how a resource reaches the API.

Everything here is the standard library, so installing the SDK pulls in nothing
else and it works in a locked-down environment. The transport is a separate
object on purpose — a caller can pass their own, and the tests do, so no test
needs the network.
"""

from __future__ import annotations

import json
import socket
import time
import urllib.error
import urllib.request
from typing import Any, Callable, Mapping, Optional, Protocol, Tuple

from .config import ResolvedConfig, redact
from .errors import (
    ConnectionError,
    FauxShieldError,
    TimeoutError,
    error_from_response,
    is_retryable,
)


#: A callable that performs one HTTP request and returns ``(status, body)``.
#: Injected so a test can answer without a socket, and so a caller can use a
#: proxy-aware opener.
Opener = Callable[[str, bytes, Mapping[str, str], float], Tuple[int, str]]


class Transport(Protocol):
    """What a resource uses to reach the API."""

    def call(
        self, endpoint: str, method: str, params: Mapping[str, Any]
    ) -> Any:  # pragma: no cover - protocol definition
        ...


class HttpTransport:
    """Posts one call to ``{base_url}/{endpoint}/{method}``.

    This is the protocol the generated Dart client speaks: a POST whose body is
    the JSON object of arguments, a bearer token when one is configured, and a
    ``200`` for success — every other status is an error body. Retries are
    limited to failures a retry can fix (connection, timeout, 429, 5xx) and they
    respect ``Retry-After`` when the server sends it.
    """

    def __init__(self, config: ResolvedConfig, opener: Optional[Opener] = None) -> None:
        self._config = config
        self._opener = opener or _urllib_opener

    def call(self, endpoint: str, method: str, params: Mapping[str, Any]) -> Any:
        request = "{}.{}".format(endpoint, method)
        url = "{}/{}/{}".format(self._config.base_url, endpoint, method)

        attempt = 0
        while True:
            try:
                return self._attempt(url, request, params)
            except FauxShieldError as error:
                if not is_retryable(error) or attempt >= self._config.max_retries:
                    raise
                time.sleep(self._delay(attempt, error))
                attempt += 1

    def _attempt(self, url: str, request: str, params: Mapping[str, Any]) -> Any:
        headers = {"content-type": "application/json"}
        if self._config.api_key:
            headers["authorization"] = "Bearer {}".format(self._config.api_key)
        payload = json.dumps(dict(params)).encode("utf-8")

        try:
            status, text = self._opener(url, payload, headers, self._config.timeout)
        except FauxShieldError:
            raise
        except socket.timeout as error:
            raise TimeoutError(
                "The request to {} timed out after {}s.".format(request, self._config.timeout),
                request=request,
            ) from error
        except urllib.error.URLError as error:
            reason = getattr(error, "reason", error)
            if isinstance(reason, socket.timeout):
                raise TimeoutError(
                    "The request to {} timed out after {}s.".format(request, self._config.timeout),
                    request=request,
                ) from error
            raise ConnectionError(
                "Could not reach the FauxShield API at {} while calling {}: {}".format(
                    self._config.base_url, request, redact(str(reason))
                ),
                request=request,
            ) from error
        except OSError as error:
            raise ConnectionError(
                "Could not reach the FauxShield API at {} while calling {}: {}".format(
                    self._config.base_url, request, redact(str(error))
                ),
                request=request,
            ) from error

        body = parse_json(text)
        if status != 200:
            raise error_from_response(status, body if body is not None else text, request)
        return body

    def _delay(self, attempt: int, error: FauxShieldError) -> float:
        if error.retry_after is not None:
            return min(error.retry_after, 30.0)
        return min(2**attempt * 0.2, 4.0)


def parse_json(text: str) -> Any:
    """Parses a JSON body, returning None when there is nothing to parse."""
    if not text.strip():
        return None
    try:
        return json.loads(text)
    except ValueError:
        return None


def _urllib_opener(
    url: str, payload: bytes, headers: Mapping[str, str], timeout: float
) -> Tuple[int, str]:
    """The default opener, over ``urllib``."""
    request = urllib.request.Request(url, data=payload, headers=dict(headers), method="POST")
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            return response.status, response.read().decode("utf-8")
    except urllib.error.HTTPError as error:
        # An error body is data, not a failure of the transport: hand the status
        # and the body back so the caller maps it like any other response.
        return error.code, error.read().decode("utf-8", errors="replace")


__all__ = ["HttpTransport", "Opener", "Transport", "parse_json"]