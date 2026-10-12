"""Every failure the SDK raises, and how a failed response maps onto one.

A typed failure arrives as HTTP ``400`` carrying the exception as the body::

    {"className": "NotFoundException", "data": {"message": "...", "code": "..."}}

so the mapping reads ``className`` first and only falls back to the status code
when the body names nothing. That fallback covers the framework's own answers —
``401``/``403`` when a credential is missing or lacks a scope, ``500`` when the
server itself failed — and a deployment that rate limits in front of the API.
The raw body is kept on the error as ``body`` for debugging, and never logged
automatically.
"""

from __future__ import annotations

from typing import Any, Dict, Optional


class FauxShieldError(Exception):
    """Base class for every error this SDK raises."""

    code = "api_error"

    def __init__(
        self,
        message: str,
        *,
        status: Optional[int] = None,
        field: Optional[str] = None,
        retry_after: Optional[float] = None,
        request: Optional[str] = None,
        body: Any = None,
    ) -> None:
        super().__init__(message)
        self.status = status
        self.field = field
        self.retry_after = retry_after
        self.request = request
        self.body = body

    def to_dict(self) -> Dict[str, Any]:
        """A plain dictionary for logs, without the response body."""
        return {
            "type": type(self).__name__,
            "code": self.code,
            "message": str(self),
            **({} if self.status is None else {"status": self.status}),
            **({} if self.field is None else {"field": self.field}),
            **({} if self.request is None else {"request": self.request}),
        }


class AuthenticationError(FauxShieldError):
    """Wrong, missing, or expired credential, or a denied scope."""

    code = "authentication"


class NotFoundError(FauxShieldError):
    """The resource does not exist, or is not visible to this credential."""

    code = "not_found"


class ValidationError(FauxShieldError):
    """The server rejected the arguments. ``field`` names the offender."""

    code = "validation"


class ConflictError(FauxShieldError):
    """The change conflicts with current state."""

    code = "conflict"


class RateLimitError(FauxShieldError):
    """Too many requests; ``retry_after`` says when to try again."""

    code = "rate_limit"


class ServiceUnavailableError(FauxShieldError):
    """The API cannot serve the request right now."""

    code = "service_unavailable"


class VerificationError(FauxShieldError):
    """A consumer verification was refused: wrong PIN, locked unit, expired session."""

    code = "verification"


class ApiError(FauxShieldError):
    """Anything else the server answered with, including 500."""

    code = "api_error"


class ConnectionError(FauxShieldError):
    """The request never reached the API: DNS, TLS, socket, or a dropped response."""

    code = "connection"


class TimeoutError(FauxShieldError):
    """The request ran past ``timeout``."""

    code = "timeout"


class FauxShieldConfigError(Exception):
    """The configuration is unusable: a bad base URL, or a nonsensical timeout."""


_EXCEPTION_CODES = {
    "ValidationException": "validation",
    "NotFoundException": "not_found",
    "AuthenticationException": "authentication",
    "ApiException": "api_error",
    "RateLimitException": "rate_limit",
    "ConflictException": "conflict",
    "ServiceUnavailableException": "service_unavailable",
    "VerificationException": "verification",
}

_BY_CODE = {
    "authentication": AuthenticationError,
    "not_found": NotFoundError,
    "validation": ValidationError,
    "conflict": ConflictError,
    "rate_limit": RateLimitError,
    "service_unavailable": ServiceUnavailableError,
    "verification": VerificationError,
    "api_error": ApiError,
    "connection": ConnectionError,
    "timeout": TimeoutError,
}


def _number_field(body: Any, *names: str) -> Optional[float]:
    """Reads a numeric field, inside ``data`` when the body nests it there."""
    if not isinstance(body, dict):
        return None
    for name in names:
        value = body.get(name)
        if isinstance(value, bool):
            continue
        if isinstance(value, (int, float)):
            return float(value)
        if isinstance(value, str):
            try:
                return float(value)
            except ValueError:
                continue
    nested = body.get("data")
    if isinstance(nested, dict):
        return _number_field(nested, *names)
    return None


def code_for_status(status: int) -> str:
    """HTTP status to error code, for a body that does not name its exception."""
    if status in (401, 403):
        return "authentication"
    if status == 404:
        return "not_found"
    if status in (400, 422):
        return "validation"
    if status == 409:
        return "conflict"
    if status == 429:
        return "rate_limit"
    if status in (502, 503, 504):
        return "service_unavailable"
    return "api_error"


def is_retryable(error: FauxShieldError) -> bool:
    """Whether a failed request is worth retrying: only what a retry can fix."""
    if error.code in ("connection", "timeout", "rate_limit", "service_unavailable"):
        return True
    return error.status == 500


def _string_field(body: Any, *names: str) -> Optional[str]:
    if not isinstance(body, dict):
        return None
    for name in names:
        value = body.get(name)
        if isinstance(value, str) and value:
            return value
    nested = body.get("data")
    if isinstance(nested, dict):
        return _string_field(nested, *names)
    return None


def error_from_response(
    status: int,
    body: Any,
    request: str,
    retry_after_header: Optional[str] = None,
) -> FauxShieldError:
    """Turns a failed response into the right error type."""
    exception_name = _string_field(body, "className", "exceptionType")
    message = _string_field(body, "message", "error", "detail")
    if message is None and isinstance(body, str) and body.strip():
        message = body.strip()
    if message is None:
        message = "The API answered {}.".format(status)

    retry_after: Optional[float] = None
    if retry_after_header:
        try:
            parsed = float(retry_after_header)
            if parsed > 0:
                retry_after = parsed
        except ValueError:
            retry_after = None
    if retry_after is None:
        # `RateLimitException` carries the delay as an integer field; a
        # deployment that rate limits in front of the API may send the header
        # instead, which is handled above.
        seconds = _number_field(body, "retryAfterSeconds", "retryAfter")
        if seconds is not None and seconds > 0:
            retry_after = seconds

    code = (_EXCEPTION_CODES.get(exception_name) if exception_name else None) or code_for_status(
        status
    )
    error_type = _BY_CODE[code]
    return error_type(
        message,
        status=status,
        field=_string_field(body, "field"),
        retry_after=retry_after,
        request=request,
        body=body,
    )
