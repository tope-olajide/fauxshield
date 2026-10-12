import assert from 'node:assert/strict';
import { test } from 'node:test';

import {
  ApiError,
  AuthenticationError,
  ConflictError,
  NotFoundError,
  RateLimitError,
  ServiceUnavailableError,
  ValidationError,
  VerificationError,
  codeForStatus,
  errorFromResponse,
  isRetryable,
} from '../dist/index.js';

test('a bare status maps to the error a caller would act on', () => {
  const cases = [
    [401, AuthenticationError],
    [403, AuthenticationError],
    [400, ValidationError],
    [404, NotFoundError],
    [409, ConflictError],
    [429, RateLimitError],
    [503, ServiceUnavailableError],
    [500, ApiError],
  ];

  for (const [status, type] of cases) {
    const error = errorFromResponse({ status, body: undefined, request: 'product.list' });
    assert.ok(error instanceof type, `status ${status} should be ${type.name}`);
    assert.equal(error.status, status);
    assert.equal(error.request, 'product.list');
  }
});

test('a typed server exception is read from its body', () => {
  const error = errorFromResponse({
    status: 400,
    body: { className: 'ValidationException', data: { message: 'SKU is taken.', field: 'sku' } },
    request: 'product.create',
  });

  assert.ok(error instanceof ValidationError);
  assert.equal(error.message, 'SKU is taken.');
  assert.equal(error.field, 'sku');
  assert.equal(error.code, 'validation');
});

test('a verification refusal keeps its own type', () => {
  const error = errorFromResponse({
    status: 400,
    body: { className: 'VerificationException', data: { message: 'Too many wrong PINs.' } },
    request: 'verification.submitPin',
  });

  assert.ok(error instanceof VerificationError);
  assert.equal(error.code, 'verification');
});

test('the body the API actually sends is understood', () => {
  // Verified against the hosted API: a typed failure is HTTP 400 with the
  // exception nested under `data`.
  const error = errorFromResponse({
    status: 400,
    body: {
      className: 'NotFoundException',
      data: {
        __className__: 'NotFoundException',
        message: 'No product with that id.',
        code: 'api_error',
        resource: 'product',
      },
    },
    request: 'product.get',
  });

  assert.ok(error instanceof NotFoundError);
  assert.equal(error.message, 'No product with that id.');
  assert.equal(error.status, 400);
  assert.equal(isRetryable(error), false);
});

test('a rate limit carries its delay from the body', () => {
  const error = errorFromResponse({
    status: 400,
    body: {
      className: 'RateLimitException',
      data: { message: 'Too many requests.', retryAfterSeconds: 42 },
    },
    request: 'product.list',
  });

  assert.ok(error instanceof RateLimitError);
  assert.equal(error.retryAfterSeconds, 42);
  assert.equal(isRetryable(error), true);
});

test('a retry-after header becomes a number of seconds', () => {
  const error = errorFromResponse({
    status: 429,
    body: undefined,
    request: 'product.list',
    retryAfter: '7',
  });

  assert.ok(error instanceof RateLimitError);
  assert.equal(error.retryAfterSeconds, 7);
});

test('only failures a retry can fix are retryable', () => {
  assert.equal(isRetryable(errorFromResponse({ status: 503, body: undefined, request: 'x' })), true);
  assert.equal(isRetryable(errorFromResponse({ status: 429, body: undefined, request: 'x' })), true);
  assert.equal(isRetryable(errorFromResponse({ status: 500, body: undefined, request: 'x' })), true);
  assert.equal(isRetryable(errorFromResponse({ status: 400, body: undefined, request: 'x' })), false);
  assert.equal(isRetryable(errorFromResponse({ status: 404, body: undefined, request: 'x' })), false);
  assert.equal(codeForStatus(418), 'api_error');
});

test('a plain text body still becomes a message', () => {
  const error = errorFromResponse({ status: 500, body: 'Internal error', request: 'x' });

  assert.equal(error.message, 'Internal error');
  assert.equal(error.code, 'api_error');
});
