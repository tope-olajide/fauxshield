"""FauxShield SDK for Python.

::

    import os
    from fauxshield import FauxShieldClient

    client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])
    for product in client.product.list(include_archived=False):
        print(product["name"])

Calls go to the hosted API unless ``base_url`` (or ``FAUXSHIELD_URL``) points
somewhere else, so a local server is one argument away::

    local = FauxShieldClient(api_key="fs_live_…", base_url="http://localhost:8080")
"""

from .client import FauxShieldClient
from .config import (
    DEFAULT_BASE_URL,
    ResolvedConfig,
    redact,
    resolve_base_url,
    resolve_config,
    validate_base_url,
)
from .errors import (
    ApiError,
    AuthenticationError,
    ConflictError,
    ConnectionError,
    FauxShieldConfigError,
    FauxShieldError,
    NotFoundError,
    RateLimitError,
    ServiceUnavailableError,
    TimeoutError,
    ValidationError,
    VerificationError,
    code_for_status,
    error_from_response,
    is_retryable,
)
from .transport import HttpTransport, Opener, Transport, parse_json

__version__ = "0.1.0"

__all__ = [
    "ApiError",
    "AuthenticationError",
    "ConflictError",
    "ConnectionError",
    "DEFAULT_BASE_URL",
    "FauxShieldClient",
    "FauxShieldConfigError",
    "FauxShieldError",
    "HttpTransport",
    "NotFoundError",
    "Opener",
    "RateLimitError",
    "ResolvedConfig",
    "ServiceUnavailableError",
    "TimeoutError",
    "Transport",
    "ValidationError",
    "VerificationError",
    "__version__",
    "code_for_status",
    "error_from_response",
    "is_retryable",
    "parse_json",
    "redact",
    "resolve_base_url",
    "resolve_config",
    "validate_base_url",
]
