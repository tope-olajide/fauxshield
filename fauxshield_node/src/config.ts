import { FauxShieldConfigError } from './errors.js';

/**
 * The hosted API this SDK talks to when nothing else is configured.
 *
 * A published SDK has to work for someone who installed it and set nothing but
 * an API key, so the default is the real deployment rather than localhost. A
 * local or staging server is opt-in through `baseUrl` or `FAUXSHIELD_URL`.
 */
export const DEFAULT_BASE_URL = 'https://fauxshield.api.serverpod.space';

/** How the client is configured. Everything here is optional. */
export interface FauxShieldConfig {
  /** API key (`fs_live_...`) or a session JWT. Falls back to `FAUXSHIELD_API_KEY`. */
  apiKey?: string;
  /** Base URL override. Falls back to `FAUXSHIELD_URL`, then {@link DEFAULT_BASE_URL}. */
  baseUrl?: string;
  /** Per-request timeout in milliseconds. Default 30000. */
  timeoutMs?: number;
  /** Retries for transient failures. Default 2, so a call is attempted at most 3 times. */
  maxRetries?: number;
  /** `fetch` implementation, for testing or a non-standard runtime. */
  fetch?: typeof globalThis.fetch;
  /** Environment source, for tests. Defaults to `process.env`. */
  environment?: Record<string, string | undefined>;
}

/** Configuration with every value resolved. */
export interface ResolvedConfig {
  apiKey?: string;
  baseUrl: string;
  timeoutMs: number;
  maxRetries: number;
  fetch: typeof globalThis.fetch;
}

/**
 * Applies the base URL rules: an explicit URL wins over the environment, which
 * wins over the hosted default. Trailing slashes are removed so paths are built
 * the same way regardless of how the URL was written.
 */
export function resolveBaseUrl(
  baseUrl: string | undefined,
  environment: Record<string, string | undefined>,
): string {
  const candidate = firstNonEmpty(baseUrl, environment['FAUXSHIELD_URL']) ?? DEFAULT_BASE_URL;
  return validateBaseUrl(candidate);
}

/** Parses and checks a base URL, with a message that says what to change. */
export function validateBaseUrl(candidate: string): string {
  let parsed: URL;
  try {
    parsed = new URL(candidate);
  } catch {
    throw new FauxShieldConfigError(
      `baseUrl is not a valid URL: "${redact(candidate)}". Expected something like https://fauxshield.api.serverpod.space.`,
    );
  }
  if (parsed.protocol !== 'https:' && parsed.protocol !== 'http:') {
    throw new FauxShieldConfigError(
      `baseUrl must use http or https, got "${parsed.protocol}".`,
    );
  }
  if (parsed.search || parsed.hash) {
    throw new FauxShieldConfigError(
      'baseUrl must not carry a query string or fragment; pass the server root only.',
    );
  }
  return parsed.origin + parsed.pathname.replace(/\/+$/, '');
}

/**
 * Resolves the configuration a client runs with.
 *
 * The API key is never included in an error message: a key in a log is a key in
 * everyone's log, and these messages travel through crash reporters.
 */
export function resolveConfig(config: FauxShieldConfig = {}): ResolvedConfig {
  const environment = config.environment ?? process.env;
  const apiKey = firstNonEmpty(config.apiKey, environment['FAUXSHIELD_API_KEY']);
  const timeoutMs = positiveInteger(config.timeoutMs ?? 30_000, 'timeoutMs');
  const maxRetries = nonNegativeInteger(config.maxRetries ?? 2, 'maxRetries');

  return {
    ...(apiKey === undefined ? {} : { apiKey }),
    baseUrl: resolveBaseUrl(config.baseUrl, environment),
    timeoutMs,
    maxRetries,
    fetch: config.fetch ?? globalThis.fetch,
  };
}

function firstNonEmpty(...values: (string | undefined)[]): string | undefined {
  for (const value of values) {
    if (typeof value === 'string' && value.trim().length > 0) return value.trim();
  }
  return undefined;
}

function positiveInteger(value: number, name: string): number {
  if (!Number.isInteger(value) || value <= 0) {
    throw new FauxShieldConfigError(`${name} must be a positive whole number of milliseconds.`);
  }
  return value;
}

function nonNegativeInteger(value: number, name: string): number {
  if (!Number.isInteger(value) || value < 0) {
    throw new FauxShieldConfigError(`${name} must be zero or a positive whole number.`);
  }
  return value;
}

/**
 * Masks anything that looks like a credential before it reaches a message.
 *
 * A mistyped base URL is the most likely way a key ends up inside one, so the
 * check is blunt on purpose: anything starting with a known credential prefix,
 * or a long opaque token, is replaced.
 */
export function redact(value: string): string {
  return value
    .replace(/fs_(live|test)_[A-Za-z0-9_]+/g, 'fs_$1_…')
    .replace(/\bey[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b/g, 'ey…');
}
