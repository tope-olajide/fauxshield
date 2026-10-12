"""The client: one transport, one resource per endpoint."""

from __future__ import annotations

from typing import Mapping, Optional

from .config import ResolvedConfig, resolve_config
from .generated.resources import (
    AlertResource,
    AnalyticsResource,
    ApiKeyResource,
    AuditResource,
    BatchResource,
    DemoResource,
    IdentityResource,
    NotificationResource,
    OfflineResource,
    ProductResource,
    RecallResource,
    SimulationResource,
    VerificationResource,
    WebhookAdminResource,
    WorkspaceResource,
)
from .transport import HttpTransport, Transport


class FauxShieldClient:
    """The FauxShield API client.

    ::

        from fauxshield import FauxShieldClient

        client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])
        products = client.product.list(include_archived=False)

    With no ``base_url`` the client talks to the hosted API; pass one (or set
    ``FAUXSHIELD_URL``) to point at a local ``serverpod start`` or a staging
    server. A ``transport`` can be supplied instead of the default HTTP one,
    which is how the tests run without a network.
    """

    def __init__(
        self,
        api_key: Optional[str] = None,
        base_url: Optional[str] = None,
        timeout: float = 30.0,
        max_retries: int = 2,
        transport: Optional[Transport] = None,
        environment: Optional[Mapping[str, str]] = None,
    ) -> None:
        config: ResolvedConfig = resolve_config(
            api_key=api_key,
            base_url=base_url,
            timeout=timeout,
            max_retries=max_retries,
            environment=environment,
        )
        #: The base URL every call goes to, after configuration is resolved.
        self.base_url = config.base_url
        caller = transport if transport is not None else HttpTransport(config)

        self.alert = AlertResource(caller)
        self.analytics = AnalyticsResource(caller)
        self.api_key = ApiKeyResource(caller)
        self.audit = AuditResource(caller)
        self.batch = BatchResource(caller)
        self.demo = DemoResource(caller)
        self.identity = IdentityResource(caller)
        self.notification = NotificationResource(caller)
        self.offline = OfflineResource(caller)
        self.product = ProductResource(caller)
        self.recall = RecallResource(caller)
        self.simulation = SimulationResource(caller)
        self.verification = VerificationResource(caller)
        self.webhook_admin = WebhookAdminResource(caller)
        self.workspace = WorkspaceResource(caller)
