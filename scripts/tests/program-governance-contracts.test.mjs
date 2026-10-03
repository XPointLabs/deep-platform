import test from 'node:test';
import { createHash } from 'node:crypto';
import assert from 'node:assert/strict';
import { copyFileSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { basename, dirname, join, resolve, sep } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

// Input-integrity guard tests only. No substituted runner can mint evidence.
const root = resolve(dirname(fileURLToPath(import.meta.url)), '../..');
const release = 'docs/survival-program/releases/v3.0.0/';
const manifestPath = release + 'program-manifest.json';
const manifest = JSON.parse(readFileSync(join(root, manifestPath), 'utf8'));
const documents = [
  'DEEP-NATIVE-CLEAN-BREAK-RU.md', 'README.md', 'specs/DEEP-CRYPTO-V1-DRAFT.md',
  'specs/DNP1-CLASSICAL-IDENTITY-RESET-MRL2-V1.md',
  'specs/DPE2-INBOUND-DURABLE-HANDOFF-AUTHORIZATION.md', 'specs/PQ-PROVIDER-FEASIBILITY.md',
].map(path => release + path);
const inputs = [
  'scripts/check-survival-program.ps1', manifestPath,
  'docs/survival-program/schemas/program-manifest.schema.json',
  'docs/survival-program/decisions/DR-0003-deep-native-session-clean-break.md',
  'docs/survival-program/PACKAGE-POLICY.md', 'AGENTS.md', 'docs/NEXT-SPRINT.md',
  ...manifest.machineSpecificationSet.paths, ...documents,
];

function run(mutate) {
  const fixture = mkdtempSync(join(resolve(tmpdir()), 'deep-program-guard-'));
  try {
    for (const relative of inputs) {
      const target = join(fixture, relative);
      mkdirSync(dirname(target), { recursive: true });
      copyFileSync(join(root, relative), target);
    }
    const read = relative => readFileSync(join(fixture, relative), 'utf8');
    const write = (relative, value) => writeFileSync(join(fixture, relative), value);
    const remove = relative => {
      const target = resolve(fixture, relative);
      assert.ok(target.startsWith(resolve(fixture) + sep));
      rmSync(target);
    };
    mutate?.({ read, write, remove });
    const result = spawnSync('pwsh', ['-NoProfile', '-File', join(fixture, inputs[0]),
      '-RequiredEvidenceClaim', 'ClassificationOnly'], {
      encoding: 'utf8', windowsHide: true, timeout: 30_000,
    });
    assert.equal(result.error, undefined, result.error?.message);
    assert.equal(result.signal, null);
    return { status: result.status, output: result.stdout + result.stderr };
  } finally {
    assert.equal(dirname(resolve(fixture)), resolve(tmpdir()));
    assert.ok(basename(fixture).startsWith('deep-program-guard-'));
    rmSync(fixture, { recursive: true, force: true });
  }
}

function reject(name, mutate, reason) {
  test(name, () => {
    const result = run(mutate);
    assert.notEqual(result.status, 0);
    assert.doesNotMatch(result.output, /Program input integrity verified/);
    assert.match(result.output, reason);
  });
}

test('exact hashes pass before the fixture rejects omitted linked/provenance inputs', () => {
  const result = run();
  assert.match(result.output, /broken local links/);
  assert.doesNotMatch(result.output, /machine specification set mismatch|program revision mismatch/);
  assert.doesNotMatch(result.output, /Program input integrity verified/);
  assert.notEqual(result.status, 0); // No linked inventory/tags/executable evidence copied.
});

reject('unknown manifest property rejects at schema boundary', ({ read, write }) => {
  const value = JSON.parse(read(manifestPath)); value.unapproved = true;
  write(manifestPath, JSON.stringify(value));
}, /not valid with the schema|schema validation failed/i);

reject('five-input historical schema cannot validate the twelve-input program', ({ read, write }) => {
  const value = JSON.parse(read(manifestPath));
  value.machineSpecificationSet.artifactCount = 5;
  value.machineSpecificationSet.paths = value.machineSpecificationSet.paths.slice(0, 5);
  write(manifestPath, JSON.stringify(value));
}, /not valid with the schema|schema validation failed/i);

reject('same-sized substituted machine set rejects independently of its digest', ({ read, write }) => {
  const value = JSON.parse(read(manifestPath));
  value.machineSpecificationSet.paths[0] = 'scripts/check-survival-program.ps1';
  write(manifestPath, JSON.stringify(value));
}, /artifact-set policy drifted/);

reject('machine path casing cannot become another canonical set', ({ read, write }) => {
  const value = JSON.parse(read(manifestPath));
  value.machineSpecificationSet.paths[0] = value.machineSpecificationSet.paths[0].replace('dnp1-classical', 'DNP1-classical');
  write(manifestPath, JSON.stringify(value));
}, /artifact-set policy drifted/);

reject('tampered machine bytes reject at the raw aggregate', ({ read, write }) => {
  const path = manifest.machineSpecificationSet.paths[0]; write(path, read(path) + '\n');
}, /machine specification set mismatch/);

reject('CRLF checkout rejects rather than repinning platform-specific bytes', ({ read, write }) => {
  const path = manifest.machineSpecificationSet.paths.at(-1);
  write(path, read(path).replaceAll('\n', '\r\n'));
}, /hashed inputs must use LF/);

reject('BOM-prefixed machine input rejects before hashing', ({ read, write }) => {
  const path = manifest.machineSpecificationSet.paths[0]; write(path, '\ufeff' + read(path));
}, /UTF-8 without BOM/);

reject('invalid UTF-8 machine bytes never get hashed as replacement characters', ({ write }) => {
  write(manifest.machineSpecificationSet.paths[0], Buffer.from([0xff]));
}, /GetString|Unable to translate bytes|DecoderFallback/i);

reject('tampered program document rejects at its independent aggregate', ({ read, write }) => {
  const path = release + 'README.md'; write(path, read(path) + '\n');
}, /program revision mismatch/);

reject('lowered document count cannot discard the sixth authorized document', ({ read, write }) => {
  const value = JSON.parse(read(manifestPath)); value.documentSet.documentCount = 5;
  write(manifestPath, JSON.stringify(value));
}, /document count 6 differs from manifest 5/);

reject('removed authorized document rejects even with a reminted smaller aggregate', ({ read, write, remove }) => {
  const omitted = release + 'specs/DPE2-INBOUND-DURABLE-HANDOFF-AUTHORIZATION.md';
  remove(omitted);
  const retained = documents.filter(path => path !== omitted);
  const hash = text => createHash('sha256').update(text).digest('hex');
  const value = JSON.parse(read(manifestPath));
  value.documentSet.documentCount = retained.length;
  value.documentSet.sha256 = hash(retained.map(path => hash(read(path)) + '  ' + path.slice(release.length) + '\n').join(''));
  write(manifestPath, JSON.stringify(value));
}, /program document-set policy drifted/);
