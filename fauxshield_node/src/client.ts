import { resolveConfig, type FauxShieldConfig } from './config.js';
import { HttpTransport, type Transport } from './transport.js';
import {
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
} from './generated/resources.js';

/**
 * The FauxShield API client.
 *
 * ```ts
 * import { FauxShieldClient } from 'fauxshield';
 *
 * const client = new FauxShieldClient({ apiKey: process.env.FAUXSHIELD_API_KEY });
 * const products = await client.product.list({ includeArchived: false });
 * ```
 *
 * With no `baseUrl` the client talks to the hosted API; pass one (or set
 * `FAUXSHIELD_URL`) to point at a local `serverpod start` or a staging server.
 */
export class FauxShieldClient {
  /** The base URL every call goes to, after configuration is resolved. */
  readonly baseUrl: string;

  readonly alert: AlertResource;
  readonly analytics: AnalyticsResource;
  readonly apiKey: ApiKeyResource;
  readonly audit: AuditResource;
  readonly batch: BatchResource;
  readonly demo: DemoResource;
  readonly identity: IdentityResource;
  readonly notification: NotificationResource;
  readonly offline: OfflineResource;
  readonly product: ProductResource;
  readonly recall: RecallResource;
  readonly simulation: SimulationResource;
  readonly verification: VerificationResource;
  readonly webhookAdmin: WebhookAdminResource;
  readonly workspace: WorkspaceResource;

  constructor(config: FauxShieldConfig = {}, transport?: Transport) {
    const resolved = resolveConfig(config);
    this.baseUrl = resolved.baseUrl;
    const caller = transport ?? new HttpTransport(resolved);

    this.alert = new AlertResource(caller);
    this.analytics = new AnalyticsResource(caller);
    this.apiKey = new ApiKeyResource(caller);
    this.audit = new AuditResource(caller);
    this.batch = new BatchResource(caller);
    this.demo = new DemoResource(caller);
    this.identity = new IdentityResource(caller);
    this.notification = new NotificationResource(caller);
    this.offline = new OfflineResource(caller);
    this.product = new ProductResource(caller);
    this.recall = new RecallResource(caller);
    this.simulation = new SimulationResource(caller);
    this.verification = new VerificationResource(caller);
    this.webhookAdmin = new WebhookAdminResource(caller);
    this.workspace = new WorkspaceResource(caller);
  }
}
