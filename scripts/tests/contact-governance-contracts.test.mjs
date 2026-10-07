import test from 'node:test';
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { copyFileSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

// Process-local guard tests, not executable crypto/package/device evidence.
// Copy only explicit public gate inputs; never secrets or a whole checkout.
const repository = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const specs = 'docs/survival-program/releases/v3.0.0/specs/';
const vectorsPath = specs + 'contact-codec-v1.vectors.json';
const anchorPath = specs + 'contact-codec-v1.vectors.anchor.json';
const executionPath = 'deep-protocol/tests/Deep.Protocol.Tests/ContactV2/CurrentContactSecurityTests.cs';
const inputs = [
  'scripts/check-contact-codec-spec.ps1', vectorsPath, anchorPath,
  specs + 'contact-codec-v1.vectors.schema.json', specs + 'deep-crypto-v1.registry.json',
  specs + 'mailbox-authorization-v3.registry.json',
  'docs/architecture/CONTACT-RESOLVER-V1.md', 'docs/architecture/CONTACT-AND-GROUP-PROTOCOL-V1.md',
  'docs/architecture/XPOINT-NETWORK-V1.md', executionPath,
];

function runFixture(mutate) {
  const fixture = mkdtempSync(join(resolve(tmpdir()), 'deep-contact-governance-'));
  try {
    for (const relative of inputs) {
      const target = join(fixture, relative);
      mkdirSync(dirname(target), { recursive: true });
      copyFileSync(join(repository, relative), target);
    }
    const read = relative => JSON.parse(readFileSync(join(fixture, relative), 'utf8'));
    const write = (relative, value) => writeFileSync(join(fixture, relative), JSON.stringify(value, null, 2) + '\n');
    const vectors = read(vectorsPath);
    mutate?.({ vectors, fixture, read, write });
    if (mutate) {
      write(vectorsPath, vectors);
      const anchor = read(anchorPath);
      anchor.sha256 = createHash('sha256').update(readFileSync(join(fixture, vectorsPath))).digest('hex');
      write(anchorPath, anchor);
    }
    const result = spawnSync('pwsh', ['-NoProfile', '-File', join(fixture, inputs[0])], {
      encoding: 'utf8', windowsHide: true, timeout: 30_000,
    });
    assert.equal(result.error, undefined, result.error?.message);
    assert.equal(result.signal, null);
    return { status: result.status, output: result.stdout + result.stderr };
  } finally {
    // Delete only this exact mkdtemp directory, using one filesystem API.
    assert.equal(dirname(resolve(fixture)), resolve(tmpdir()));
    assert.ok(basename(fixture).startsWith('deep-contact-governance-'));
    rmSync(fixture, { recursive: true, force: true });
  }
}

function rejects(name, mutate, reason) {
  test(name, () => {
    const result = runFixture(mutate);
    assert.notEqual(result.status, 0);
    assert.match(result.output, reason);
  });
}

test('current retained neutral input passes without implying crypto execution', () => {
  const result = runFixture();
  assert.equal(result.status, 0, result.output);
  assert.match(result.output, /not executable\/package\/physical evidence/);
});

rejects('a missing positive target rejects even with a reminted fixture anchor',
  ({ vectors }) => vectors.primitives.pop(), /Value should have at least 13 items at '\/primitives'|primitive targets\/order/);
rejects('an allowed but substituted positive target cannot preserve the count',
  ({ vectors }) => { vectors.primitives[0].target = 'XUR1'; }, /primitive targets\/order/);
rejects('retired DCB1 positive input cannot return',
  ({ vectors }) => { vectors.primitives[0].target = 'DCB1'; }, /The string value is not a match for the indicated regular expression at[\s\S]*'\/primitives\/0\/target'|retired positive contact input/);
rejects('retired XMG1 positive input cannot return',
  ({ vectors }) => { vectors.records[0].target = 'XMG1'; }, /The string value is not a match|retired positive contact input/);
rejects('the retired XMG1 signature purpose cannot return in the current machine contract',
  ({ read, write }) => {
    const path = specs + 'mailbox-authorization-v3.registry.json';
    const contract = read(path); contract.acquisitionRequest.signatureDomain = 'Deep/ContactResolver/V1/XMG1'; write(path, contract);
  }, /XMG2 machine route\/signature contract/);
rejects('the route hash cannot silently move outside the signed current request projection',
  ({ read, write }) => {
    const path = specs + 'mailbox-authorization-v3.registry.json';
    const contract = read(path); contract.acquisitionRequest.exactRouteHashTag = 12; write(path, contract);
  }, /XMG2 machine route\/signature contract/);
rejects('damaged exact primitive bytes reject at their independent hash',
  ({ vectors }) => { vectors.primitives[0].fixtureBytesHex = '00' + vectors.primitives[0].fixtureBytesHex.slice(2); }, /fixture hash/);
rejects('a changed signature input rejects despite a correct whole-document anchor',
  ({ vectors }) => { vectors.ed25519Fixtures[0].signatureInputHex = '00' + vectors.ed25519Fixtures[0].signatureInputHex.slice(2); }, /Ed25519 signature input/);
rejects('a removed hostile input cannot be hidden behind a lower count',
  ({ vectors }) => vectors.hostileFixtures.pop(), /Value should have at least 8 items at '\/hostileFixtures'|hostile fixture ids/);
rejects('a removed policy negative rejects',
  ({ vectors }) => vectors.negativeCases.pop(), /Value should have at least 7 items at '\/negativeCases'|negative coverage ids/);
rejects('a nonzero external mutation callback declaration rejects',
  ({ vectors }) => { vectors.negativeCases[0].callbacks.mutation = 1; }, /The JSON is not valid with the schema: Expected[\s\S]*'\/negativeCases\/0\/callbacks'|negative callbacks/);
rejects('an ID without an executable mapping rejects', ({ fixture }) => {
  const path = join(fixture, executionPath);
  const source = readFileSync(path, 'utf8').replaceAll('xrc-pmt-xnv-binding', 'unmapped-current-negative');
  writeFileSync(path, source);
}, /missing executable negative xrc-pmt-xnv-binding/);
