import assert from 'node:assert/strict';
import { test } from 'node:test';

import {
  DEFAULT_BASE_URL,
  FauxShieldConfigError,
  redact,
  resolveBaseUrl,
  resolveConfig,
  validateBaseUrl,
} from '../dist/index.js';

test('the built-in default is the hosted API, never localhost', () => {
  assert.equal(DEFAULT_BASE_URL, 'https://fauxshield.api.serverpod.space');
  assert.match(DEFAULT_BASE_URL, /^https:\/\//);
  assert.doesNotMatch(DEFAULT_BASE_URL, /localhost|127\.0\.0\.1/);
  assert.equal(resolveBaseUrl(undefined, {}), DEFAULT_BASE_URL);
});

test('FAUXSHIELD_URL points the client at a development server', () => {
  assert.equal(
    resolveBaseUrl(undefined, { FAUXSHIELD_URL: 'http://localhost:8080' }),
    'http://localhost:8080',
  );
});

test('an explicit base URL beats the environment and the default', () => {
  assert.equal(
    resolveBaseUrl('https://staging.example.test', {
      FAUXSHIELD_URL: 'http://localhost:8080',
    }),
    'https://staging.example.test',
  );
});

test('a trailing slash does not turn into a double slash in the path', () => {
  assert.equal(validateBaseUrl('https://api.example.test/'), 'https://api.example.test');
  assert.equal(validateBaseUrl('https://api.example.test/base/'), 'https://api.example.test/base');
});

test('an unusable base URL is refused with advice, not a crash', () => {
  assert.throws(() => validateBaseUrl('not-a-url'), FauxShieldConfigError);
  assert.throws(() => validateBaseUrl('ftp://api.example.test'), /http or https/);
  assert.throws(() => validateBaseUrl('https://api.example.test/?x=1'), /query string/);
});

test('the API key comes from the config or the environment, never an error', () => {
  assert.equal(resolveConfig({ apiKey: 'fs_live_a' }).apiKey, 'fs_live_a');
  assert.equal(
    resolveConfig({ environment: { FAUXSHIELD_API_KEY: 'fs_live_env' } }).apiKey,
    'fs_live_env',
  );
  assert.equal(resolveConfig({ environment: {} }).apiKey, undefined);

  try {
    validateBaseUrl('https://api.example.test/?key=fs_live_abcdefghijkl');
    assert.fail('expected a configuration error');
  } catch (error) {
    assert.ok(error instanceof FauxShieldConfigError);
    assert.doesNotMatch(error.message, /fs_live_abcdefghijkl/);
  }
});

test('timeouts and retries are validated as whole numbers', () => {
  assert.equal(resolveConfig({ timeoutMs: 1_000, maxRetries: 0 }).timeoutMs, 1_000);
  assert.equal(resolveConfig({ maxRetries: 0 }).maxRetries, 0);
  assert.throws(() => resolveConfig({ timeoutMs: 0 }), FauxShieldConfigError);
  assert.throws(() => resolveConfig({ maxRetries: -1 }), FauxShieldConfigError);
  assert.throws(() => resolveConfig({ timeoutMs: 1.5 }), FauxShieldConfigError);
});

test('secrets are masked before they reach a message', () => {
  assert.equal(redact('fs_live_abcdefghijklmnop'), 'fs_live_…');
  assert.equal(
    redact('failed to reach https://x.test with fs_live_abcdefghijklmnop'),
    'failed to reach https://x.test with fs_live_…',
  );
});
