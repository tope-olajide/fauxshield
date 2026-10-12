import type { ResolvedConfig } from './config.js';
import { ConnectionError, FauxShieldError, TimeoutError, errorFromResponse, isRetryable } from './errors.js';
import { redact } from './config.js';

/** How a resource reaches the API. Injectable so tests need no network. */
export interface Transport {
  call(
    endpoint: string,
    method: string,
    params: Record<string, unknown>,
  ): Promise<unknown>;
}

/**
 * Posts one call to `{baseUrl}/{endpoint}/{method}`.
 *
 * This is the protocol the generated Dart client speaks: a POST whose body is
 * the JSON object of arguments, a bearer token when one is configured, and a
 * `200` for success — every other status is an error body. Retries are limited
 * to failures a retry can actually fix (connection, timeout, `429`, `503`, and
 * `500`), and they respect `Retry-After` when the server sends it.
 */
export class HttpTransport implements Transport {
  constructor(private readonly config: ResolvedConfig) {}

  async call(
    endpoint: string,
    method: string,
    params: Record<string, unknown>,
  ): Promise<unknown> {
    const request = `${endpoint}.${method}`;
    const url = `${this.config.baseUrl}/${endpoint}/${method}`;

    for (let attempt = 0; ; attempt += 1) {
      try {
        return await this.attempt(url, request, params);
      } catch (error) {
        if (
          !(error instanceof FauxShieldError) ||
          !isRetryable(error) ||
          attempt >= this.config.maxRetries
        ) {
          throw error;
        }
        await sleep(this.delayFor(attempt, error));
      }
    }
  }

  private async attempt(
    url: string,
    request: string,
    params: Record<string, unknown>,
  ): Promise<unknown> {
    const signal = AbortSignal.timeout(this.config.timeoutMs);
    const headers: Record<string, string> = { 'content-type': 'application/json' };
    if (this.config.apiKey !== undefined) {
      headers['authorization'] = `Bearer ${this.config.apiKey}`;
    }

    let response: Response;
    try {
      response = await this.config.fetch(url, {
        method: 'POST',
        headers,
        body: JSON.stringify(params ?? {}),
        signal,
      });
    } catch (cause) {
      const detail = cause instanceof Error ? cause.message : String(cause);
      if (signal.aborted || (cause instanceof Error && cause.name === 'TimeoutError')) {
        throw new TimeoutError(
          `The request to ${request} timed out after ${this.config.timeoutMs}ms.`,
          { request, cause },
        );
      }
      throw new ConnectionError(
        `Could not reach the FauxShield API at ${this.config.baseUrl} ` +
          `while calling ${request}: ${redact(detail)}`,
        { request, cause },
      );
    }

    const text = await response.text();
    const body = parseJson(text);

    if (response.status !== 200) {
      throw errorFromResponse({
        status: response.status,
        body: body ?? text,
        request,
        retryAfter: response.headers.get('retry-after'),
      });
    }
    return body;
  }

  /** Seconds the server asked for, or a short exponential backoff. */
  private delayFor(attempt: number, error: FauxShieldError): number {
    if (error.retryAfterSeconds !== undefined) {
      return Math.min(error.retryAfterSeconds, 30) * 1000;
    }
    return Math.min(2 ** attempt * 200, 4_000);
  }
}

/** Parses a JSON body, returning undefined when there is nothing to parse. */
export function parseJson(text: string): unknown {
  if (text.trim().length === 0) return undefined;
  try {
    return JSON.parse(text) as unknown;
  } catch {
    return undefined;
  }
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
