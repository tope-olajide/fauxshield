"""Client configuration: the hosted default, and how to point somewhere else."""

from __future__ import annotations

import os
import re
from dataclasses import dataclass
from typing import Mapping, Optional
from urllib.parse import urlparse

from .errors import FauxShieldConfigError

#: The hosted API this SDK talks to when nothing else is configured.
#:
#: A published SDK has to work for someone who installed it and set nothing but
#: an API key, so the default is the real deployment rather than localhost. A
#: local or staging server is opt-in through ``base_url`` or
#: ``FAUXSHIELD_URL``.
DEFAULT_BASE_URL = "https://fauxshield.api.serverpod.space"

_KEY_PATTERN = re.compile(r"fs_(live|test)_[A-Za-z0-9_]+")
_JWT_PATTERN = re.compile(r"\bey[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b")


@dataclass(frozen=True)
class ResolvedConfig:
    """Configuration with every value resolved."""

    base_url: str
    api_key: Optional[str] = None
    timeout: float = 30.0
    max_retries: int = 2


def redact(value: str) -> str:
    """Masks anything that looks like a credential.

    A mistyped base URL is the most likely way a key ends up inside a message,
    so this is blunt on purpose: a key prefix, or a long opaque token, is
    replaced before the text reaches a log.
    """
    return _JWT_PATTERN.sub("ey…", _KEY_PATTERN.sub(r"fs_\1_…", value))


def resolve_base_url(
    base_url: Optional[str],
    environment: Mapping[str, str],
) -> str:
    """Applies the base URL rules: explicit wins, then the environment, then the default."""
    candidate = _first_non_empty(base_url, environment.get("FAUXSHIELD_URL")) or DEFAULT_BASE_URL
    return validate_base_url(candidate)


def validate_base_url(candidate: str) -> str:
    """Parses and checks a base URL, with a message that says what to change."""
    parsed = urlparse(candidate)
    if parsed.scheme not in ("http", "https") or not parsed.netloc:
        raise FauxShieldConfigError(
            'base_url must be an http or https URL, got "{}". Expected something like {}.'.format(
                redact(candidate), DEFAULT_BASE_URL
            )
        )
    if parsed.query or parsed.fragment:
        raise FauxShieldConfigError(
            "base_url must not carry a query string or fragment; pass the server root only."
        )
    path = parsed.path.rstrip("/")
    return "{}://{}{}".format(parsed.scheme, parsed.netloc, path)


def resolve_config(
    api_key: Optional[str] = None,
    base_url: Optional[str] = None,
    timeout: float = 30.0,
    max_retries: int = 2,
    environment: Optional[Mapping[str, str]] = None,
) -> ResolvedConfig:
    """Resolves the configuration a client runs with.

    The API key is never included in an error message: a key in a log is a key
    in everyone's log, and these messages travel through crash reporters.
    """
    env = os.environ if environment is None else environment
    resolved_key = _first_non_empty(api_key, env.get("FAUXSHIELD_API_KEY"))

    if timeout <= 0:
        raise FauxShieldConfigError("timeout must be a positive number of seconds.")
    if max_retries < 0 or not isinstance(max_retries, int):
        raise FauxShieldConfigError("max_retries must be zero or a positive whole number.")

    return ResolvedConfig(
        base_url=resolve_base_url(base_url, env),
        api_key=resolved_key,
        timeout=float(timeout),
        max_retries=max_retries,
    )


def _first_non_empty(*values: Optional[str]) -> Optional[str]:
    for value in values:
        if isinstance(value, str) and value.strip():
            return value.strip()
    return None
