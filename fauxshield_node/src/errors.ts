/**
 * Every failure this SDK raises is a `FauxShieldError`, so a caller can catch
 * one type and still tell the cases apart by `code` or by the subclass.
 *
 * A typed failure arrives as HTTP `400` carrying the exception as the body —
 * `{ className, data: { __className__, message, code, ... } }` — so the mapping
 * reads `className` first and only falls back to the status code when the body
 * does not name an exception. That fallback is for the framework's own
 * responses: `401`/`403` when a credential is missing or lacks a scope, and
 * `500` when the server fails. The raw body is kept on the error as `body` for
 * debugging, and never logged automatically.
 */

export type FauxShieldErrorCode =
  | 'authentication'
  | 'not_found'
  | 'validation'
  | 'rate_limit'
  | 'conflict'
  | 'service_unavailable'
  | 'verification'
  | 'api_error'
  | 'connection'
  | 'timeout';

export class FauxShieldError extends Error {
  readonly code: FauxShieldErrorCode;
  /** HTTP status, when the failure came from a response. */
  readonly status?: number;
  /** Field the server rejected, when the error names one. */
  readonly field?: string;
  /** Seconds to wait before retrying, from a `Retry-After` header or body. */
  readonly retryAfterSeconds?: number;
  /** The endpoint and method that failed, for example `product.list`. */
  readonly request?: string;
  /** Response body as received, for debugging. */
  readonly body?: unknown;

  constructor(
    message: string,
    options: {
      code: FauxShieldErrorCode;
      status?: number;
      field?: string;
      retryAfterSeconds?: number;
      request?: string;
      body?: unknown;
      cause?: unknown;
    },
  ) {
    super(message, options.cause === undefined ? undefined : { cause: options.cause });
    this.name = new.target.name;
    this.code = options.code;
    this.status = options.status;
    this.field = options.field;
    this.retryAfterSeconds = options.retryAfterSeconds;
    this.request = options.request;
    this.body = options.body;
  }

  /** A plain object for logs, without the request body. */
  toJSON(): Record<string, unknown> {
    return {
      name: this.name,
      code: this.code,
      message: this.message,
      ...(this.status === undefined ? {} : { status: this.status }),
      ...(this.field === undefined ? {} : { field: this.field }),
      ...(this.request === undefined ? {} : { request: this.request }),
    };
  }
}

/** Wrong, missing, or expired credential, or a denied scope. */
export class AuthenticationError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'authentication' });
  }
}

/** The resource does not exist, or is not visible to this credential. */
export class NotFoundError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'not_found' });
  }
}

/** The server rejected the arguments (`400`). `field` names the offender. */
export class ValidationError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'validation' });
  }
}

/** Too many requests; `retryAfterSeconds` says when to try again. */
export class RateLimitError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'rate_limit' });
  }
}

/** The request conflicts with current state, for example a duplicate SKU. */
export class ConflictError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'conflict' });
  }
}

/** The API cannot serve the request right now, or a dependency is unset. */
export class ServiceUnavailableError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'service_unavailable' });
  }
}

/** A consumer verification was refused: wrong PIN, locked unit, expired session. */
export class VerificationError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'verification' });
  }
}

/** Anything else the server answered with, including `500`. */
export class ApiError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'api_error' });
  }
}

/** The request never reached the API: DNS, TLS, socket, or a dropped response. */
export class ConnectionError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'connection' });
  }
}

/** The request exceeded `timeoutMs`. */
export class TimeoutError extends FauxShieldError {
  constructor(message: string, options: Omit<ConstructorParameters<typeof FauxShieldError>[1], 'code'>) {
    super(message, { ...options, code: 'timeout' });
  }
}

/** The configuration is unusable — a bad base URL, or a missing key. */
export class FauxShieldConfigError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'FauxShieldConfigError';
  }
}

const knownExceptionCode: Record<string, FauxShieldErrorCode> = {
  ValidationException: 'validation',
  NotFoundException: 'not_found',
  AuthenticationException: 'authentication',
  ApiException: 'api_error',
  RateLimitException: 'rate_limit',
  ConflictException: 'conflict',
  ServiceUnavailableException: 'service_unavailable',
  VerificationException: 'verification',
};

/** Reads a string field from an unknown JSON body. */
function stringField(body: unknown, ...names: string[]): string | undefined {
  if (typeof body !== 'object' || body === null) return undefined;
  const record = body as Record<string, unknown>;
  for (const name of names) {
    const value = record[name];
    if (typeof value === 'string' && value.length > 0) return value;
  }
  const nested = record['data'];
  if (typeof nested === 'object' && nested !== null) {
    return stringField(nested, ...names);
  }
  return undefined;
}

/** Reads a number field from an unknown JSON body, inside `data` if need be. */
function numberField(body: unknown, ...names: string[]): number | undefined {
  if (typeof body !== 'object' || body === null) return undefined;
  const record = body as Record<string, unknown>;
  for (const name of names) {
    const value = record[name];
    if (typeof value === 'number' && Number.isFinite(value)) return value;
    if (typeof value === 'string') {
      const parsed = Number.parseInt(value, 10);
      if (Number.isFinite(parsed)) return parsed;
    }
  }
  const nested = record['data'];
  if (typeof nested === 'object' && nested !== null) {
    return numberField(nested, ...names);
  }
  return undefined;
}

/**
 * Turns a failed response into the right error type.
 *
 * Exported because the transport uses it and tests exercise it directly.
 */
export function errorFromResponse(options: {
  status: number;
  body: unknown;
  request: string;
  retryAfter?: string | null;
}): FauxShieldError {
  const { status, body, request } = options;
  const className = stringField(body, 'className', 'exceptionType');
  const message =
    stringField(body, 'message', 'error', 'detail') ??
    (typeof body === 'string' && body.trim().length > 0 ? body.trim() : undefined) ??
    `The API answered ${status}.`;
  const field = stringField(body, 'field');
  const retryAfterSeconds = (() => {
    const header = options.retryAfter;
    if (header) {
      const seconds = Number.parseInt(header, 10);
      if (Number.isFinite(seconds) && seconds > 0) return seconds;
    }
    // `RateLimitException` carries the delay as an integer field, and a
    // deployment that rate limits in front of the API may send the header
    // instead, which is handled above.
    const fromBody = numberField(body, 'retryAfterSeconds', 'retryAfter');
    if (fromBody !== undefined && fromBody > 0) return fromBody;
    return undefined;
  })();

  const base = { status, field, retryAfterSeconds, request, body };

  const fromBody = className ? knownExceptionCode[className] : undefined;
  const code = fromBody ?? codeForStatus(status);
  switch (code) {
    case 'authentication':
      return new AuthenticationError(message, base);
    case 'not_found':
      return new NotFoundError(message, base);
    case 'validation':
      return new ValidationError(message, base);
    case 'rate_limit':
      return new RateLimitError(message, base);
    case 'conflict':
      return new ConflictError(message, base);
    case 'service_unavailable':
      return new ServiceUnavailableError(message, base);
    case 'verification':
      return new VerificationError(message, base);
    default:
      return new ApiError(message, base);
  }
}

/** HTTP status to error code, for a body that does not name its exception. */
export function codeForStatus(status: number): FauxShieldErrorCode {
  // The fallback for a body that does not name its exception: the framework's
  // own auth responses, and whatever a proxy in front of the API answers.
  if (status === 401 || status === 403) return 'authentication';
  if (status === 404) return 'not_found';
  if (status === 400 || status === 422) return 'validation';
  if (status === 409) return 'conflict';
  if (status === 429) return 'rate_limit';
  if (status === 502 || status === 503 || status === 504) return 'service_unavailable';
  return 'api_error';
}

/** Whether a failed request is worth retrying: nothing that a retry cannot fix. */
export function isRetryable(error: FauxShieldError): boolean {
  if (error.code === 'connection' || error.code === 'timeout') return true;
  if (error.code === 'rate_limit') return true;
  if (error.code === 'service_unavailable') return true;
  return error.status === 500;
}
