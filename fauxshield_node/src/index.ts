/**
 * FauxShield SDK for Node.js and TypeScript.
 *
 * ```ts
 * import { FauxShieldClient } from 'fauxshield';
 *
 * const client = new FauxShieldClient({ apiKey: process.env.FAUXSHIELD_API_KEY });
 * const [product] = await client.product.list({ includeArchived: false });
 * console.log(product?.name);
 * ```
 *
 * Calls go to the hosted API unless `baseUrl` (or `FAUXSHIELD_URL`) points
 * somewhere else, so a local server is one option away:
 *
 * ```ts
 * const local = new FauxShieldClient({
 *   apiKey: 'fs_live_…',
 *   baseUrl: 'http://localhost:8080',
 * });
 * ```
 */

export { FauxShieldClient } from './client.js';

export {
  DEFAULT_BASE_URL,
  resolveBaseUrl,
  resolveConfig,
  validateBaseUrl,
  redact,
  type FauxShieldConfig,
  type ResolvedConfig,
} from './config.js';

export {
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
  codeForStatus,
  errorFromResponse,
  isRetryable,
  type FauxShieldErrorCode,
} from './errors.js';

export { HttpTransport, parseJson, type Transport } from './transport.js';

export * from './generated/models.js';
export * from './generated/resources.js';
