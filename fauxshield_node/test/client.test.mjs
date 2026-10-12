import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';

import { DEFAULT_BASE_URL, FauxShieldClient } from '../dist/index.js';

const here = dirname(fileURLToPath(import.meta.url));
const contract = JSON.parse(
  readFileSync(join(here, '..', '..', 'fauxshield_contract', 'contract', 'api_contract.json'), 'utf8'),
);

/** Records every call instead of reaching the network. */
class RecordingTransport {
  calls = [];

  async call(endpoint, method, params) {
    this.calls.push({ endpoint, method, params });
    return { endpoint, method };
  }
}

/** A placeholder argument for one contract type. */
function sampleValue(type, contract_) {
  const list = /^List<(.+)>$/.exec(type);
  if (list) return [];
  const map = /^Map</.exec(type);
  if (map) return {};
  if (type === 'String' || type === 'UuidValue' || type === 'DateTime') return 'sample';
  if (type === 'int' || type === 'double' || type === 'num' || type === 'Duration') return 1;
  if (type === 'bool') return true;

  const enumValue = contract_.enums.find((value) => value.name === type);
  if (enumValue) return enumValue.values[0];
  const model = contract_.models.find((value) => value.name === type);
  if (model) {
    return Object.fromEntries(
      model.fields
        .filter((field) => !field.nullable)
        .map((field) => [field.name, sampleValue(field.type, contract_)]),
    );
  }
  return {};
}

test('the client defaults to the hosted API and takes an override', () => {
  assert.equal(
    new FauxShieldClient({ environment: {}, apiKey: 'fs_live_x' }).baseUrl,
    DEFAULT_BASE_URL,
  );
  assert.equal(
    new FauxShieldClient({
      environment: { FAUXSHIELD_URL: 'http://localhost:8080' },
      apiKey: 'fs_live_x',
    }).baseUrl,
    'http://localhost:8080',
  );
});

test('every endpoint of the contract is a resource on the client', () => {
  const client = new FauxShieldClient(
    { apiKey: 'fs_live_x', environment: {} },
    new RecordingTransport(),
  );

  for (const endpoint of contract.endpoints) {
    const resource = client[endpoint.name];
    assert.ok(resource, `client.${endpoint.name} is missing`);
    for (const method of endpoint.methods) {
      assert.equal(
        typeof resource[method.name],
        'function',
        `client.${endpoint.name}.${method.name} is missing`,
      );
    }
  }
});

test('every method sends its endpoint, method name, and arguments', async () => {
  const transport = new RecordingTransport();
  const client = new FauxShieldClient({ apiKey: 'fs_live_x', environment: {} }, transport);

  let calls = 0;
  for (const endpoint of contract.endpoints) {
    const resource = client[endpoint.name];
    for (const method of endpoint.methods) {
      const params = Object.fromEntries(
        method.params.map((param) => [param.name, sampleValue(param.type, contract)]),
      );
      const result = await resource[method.name](params);

      const call = transport.calls.at(-1);
      assert.equal(call.endpoint, endpoint.name);
      assert.equal(call.method, method.name);
      assert.deepEqual(call.params, params);
      assert.deepEqual(result, { endpoint: endpoint.name, method: method.name });
      calls += 1;
    }
  }

  assert.equal(calls, contract.endpoints.reduce((sum, e) => sum + e.methods.length, 0));
});

test('a method with nothing required runs without arguments', async () => {
  const transport = new RecordingTransport();
  const client = new FauxShieldClient({ apiKey: 'fs_live_x', environment: {} }, transport);

  const resourceless = contract.endpoints
    .flatMap((endpoint) => endpoint.methods.map((method) => ({ endpoint, method })))
    .find(({ method }) => method.params.length === 0);

  if (!resourceless) return; // Every method takes at least one argument today.

  await client[resourceless.endpoint.name][resourceless.method.name]();
  assert.equal(transport.calls.at(-1).method, resourceless.method.name);
});

test('a documented call reaches the documented endpoint', async () => {
  const transport = new RecordingTransport();
  const client = new FauxShieldClient({ apiKey: 'fs_live_x', environment: {} }, transport);

  await client.product.list({ includeArchived: false });

  assert.deepEqual(transport.calls[0], {
    endpoint: 'product',
    method: 'list',
    params: { includeArchived: false },
  });
});
