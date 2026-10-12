import assert from 'node:assert/strict';
import { test } from 'node:test';

import {
  AuthenticationError,
  ConnectionError,
  FauxShieldClient,
  ServiceUnavailableError,
  TimeoutError,
} from '../dist/index.js';

/** A `fetch` that answers from a queue and records what it was asked. */
function fakeFetch(responses) {
  const calls = [];
  return {
    calls,
    fetch: async (url, init) => {
      calls.push({ url, init });
      const next = responses.shift();
      if (typeof next === 'function') return next(url, init);
      if (next instanceof Error) throw next;
      return new Response(next.body ?? '', {
        status: next.status,
        headers: next.headers ?? {},
      });
    },
  };
}

function client(fetch, config = {}) {
  return new FauxShieldClient(
    {
      apiKey: 'fs_live_testkey',
      baseUrl: 'https://api.example.test',
      maxRetries: 0,
      fetch,
      environment: {},
      ...config,
    },
  );
}

test('a call is a POST to endpoint/method with the args as JSON', async () => {
  const fake = fakeFetch([{ status: 200, body: '{"id":"p1"}' }]);
  const result = await client(fake.fetch).product.list({ includeArchived: false });

  assert.deepEqual(result, { id: 'p1' });
  assert.equal(fake.calls.length, 1);
  assert.equal(fake.calls[0].url, 'https://api.example.test/product/list');
  assert.equal(fake.calls[0].init.method, 'POST');
  assert.equal(fake.calls[0].init.headers['content-type'], 'application/json');
  assert.equal(fake.calls[0].init.headers['authorization'], 'Bearer fs_live_testkey');
  assert.deepEqual(JSON.parse(fake.calls[0].init.body), { includeArchived: false });
});

test('an empty success body is undefined, not an error', async () => {
  const fake = fakeFetch([{ status: 200, body: '' }]);

  assert.equal(await client(fake.fetch).product.list({}), undefined);
});

test('a failed call raises the mapped error and is not retried when it cannot help', async () => {
  const fake = fakeFetch([{ status: 401, body: '{}' }]);

  await assert.rejects(
    () => client(fake.fetch, { maxRetries: 3 }).product.list({}),
    AuthenticationError,
  );
  assert.equal(fake.calls.length, 1);
});

test('a transient failure is retried, and a later success is returned', async () => {
  const fake = fakeFetch([
    { status: 503, body: '{}', headers: { 'retry-after': '0' } },
    { status: 200, body: '{"ok":true}' },
  ]);

  assert.deepEqual(await client(fake.fetch, { maxRetries: 2 }).product.list({}), { ok: true });
  assert.equal(fake.calls.length, 2);
});

test('retries stop at maxRetries and raise the last failure', async () => {
  const fake = fakeFetch([
    { status: 503, body: '{}' },
    { status: 503, body: '{}' },
    { status: 503, body: '{}' },
  ]);

  await assert.rejects(
    () => client(fake.fetch, { maxRetries: 1, timeoutMs: 1_000 }).product.list({}),
    ServiceUnavailableError,
  );
  assert.equal(fake.calls.length, 2, 'one attempt plus one retry');
});

test('a request that runs past the timeout raises TimeoutError', async () => {
  const fake = fakeFetch([
    (_url, init) =>
      new Promise((_resolve, reject) => {
        init.signal.addEventListener('abort', () => reject(init.signal.reason));
      }),
  ]);

  await assert.rejects(
    () => client(fake.fetch, { timeoutMs: 50 }).product.list({}),
    (error) => {
      assert.ok(error instanceof TimeoutError);
      assert.match(error.message, /timed out after 50ms/);
      return true;
    },
  );
});

test('a socket failure becomes ConnectionError without leaking the key', async () => {
  const fake = fakeFetch([new Error('getaddrinfo ENOTFOUND api.example.test')]);

  await assert.rejects(
    () => client(fake.fetch).product.list({}),
    (error) => {
      assert.ok(error instanceof ConnectionError);
      assert.match(error.message, /https:\/\/api\.example\.test/);
      assert.doesNotMatch(error.message, /fs_live_testkey/);
      return true;
    },
  );
});
