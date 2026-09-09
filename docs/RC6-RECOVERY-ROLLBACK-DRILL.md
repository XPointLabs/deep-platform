# RC-6 recovery and rollback drill

This runbook is the release contract for a real, volume-backed snapshot and restore rehearsal. A
unit test that reloads an in-memory fixture is useful, but it does not satisfy this drill. The drill
must archive stopped Docker state, restore it into a newly created isolated volume, compare the
restored bytes and filesystem metadata, start the pinned recovery contour, and prove application
state is still usable.

The production environment is not changed by this procedure. Production execution requires a
separate deployment decision. Run the rehearsal on the release/UAT topology with the same image
digests, volume layout and protected-material classes that production will use.

## Recovery inventory

The release manifest must classify every item below as `state`, `protected-material`,
`reconstructible`, or `external-authority`. An item cannot be silently omitted.

| Contour | Required recovery inventory |
| --- | --- |
| XPoint node state | `xnode-state`, `xnode-config`, `node-storage-state`; ingress preflight attestation may be reconstructed only from the same verified certificate profile |
| XPoint node identity | Ed25519 node identity, independent X25519 privacy-routing private key, BLS signing key, VLESS client identity, Reality private/public key pair and short ID |
| Node ingress trust | current and next certificate/key pairs, both SPKI inputs, certificate profile and signed topology/route authority |
| Registry | registry state plus durable `calls-v2` signal/replay state in the same protected volume, membership projection/checkpoints and signed membership-route artifact |
| Client services | storage state, file state, push database, and the release manifest that pins their image digests and state-schema versions |
| Service credentials | TURN shared secret, push internal token, push database credential and provider credential; only protected-store versions/checksums belong in inventory, never values |
| External authority | on-chain deployment addresses and start block, DNS/TLS ownership, release-signing authority and immutable image/package digests |

The Ed25519, X25519 and BLS keys are different roles. Losing the X25519 key breaks the node's
published privacy-route contact even if the Ed25519 identity survives. Never generate a replacement
and call it a restore. A replacement is a new identity/topology generation and follows the normal
rotation or exit/re-registration procedure.

## Preconditions

1. Pin every application image and the snapshot tool image by `sha256` in the candidate manifest.
2. Select an encrypted backup destination outside the source tree and evidence directory.
3. Capture safe pre-drill probes: schema versions, counts, readiness outcomes and hashes of dedicated
   canary records. Do not capture payloads, account/device/node IDs, credentials, paths or logs.
4. Quiesce writes, then stop every container mounting the target volume. Database-backed services
   must complete their native checkpoint/backup step before their volume is archived.
5. Confirm that `docker ps --filter volume=<volume>` returns no running container. The drill script
   repeats this check and fails closed.

An online tar of a changing database is not a backup. PostgreSQL must use its native consistent
backup/restore procedure or be shut down cleanly before the volume snapshot. The registry, XNode,
storage and file writers must also be stopped before their volumes are read.

## Real volume snapshot and isolated restore

Run this once for each state volume in the release inventory. `ToolImage` must be an immutable image
from the candidate manifest that contains GNU tar; a floating tag is rejected.

```powershell
pwsh ./scripts/Invoke-Rc6VolumeRecoveryDrill.ps1 `
  -SourceVolume '<stopped-source-volume>' `
  -BackupDirectory '<encrypted-backup-destination>' `
  -ToolImage '<tool-image>@sha256:<digest>' `
  -EvidencePath '<evidence-root>/volume-recovery.json'
```

The script performs the volume snapshot/restore stage only; its evidence deliberately sets
`scope=volume-snapshot-restore-only`, `applicationContourValidated=false`, and
`releaseDrillComplete=false`. A `passed` status means only that this stage passed and must never be
reported as release-drill completion. The script creates a new volume with the
`deep-rc6-restore-` prefix, restores the archive there, builds canonical GNU-tar manifests for the
source and restored trees, compares their SHA-256 values, and removes only that newly created volume.
It refuses to read a volume mounted by a running container. `-KeepRestoredVolume` is allowed only
when the next step will boot an isolated recovery stack; the operator remains responsible for
removing that drill volume afterward.

A live writer is reported as `source-volume-has-running-writers`; this result cannot be overridden.

The archive is sensitive backup material, not release evidence. Store it encrypted under backup
retention policy. The JSON evidence contains only status, UTC time, byte length, SHA-256 values,
writer count and whether the isolated volume was retained. It contains no source volume name, host
path, container ID, application identifier or payload.

## Boot and state-preservation checks

Attach retained restore volumes only to an isolated Compose project with no production DNS, public
ports, push provider or signing side effects. Start the exact candidate images and require readiness
before probes.

The current RC6 application recovery verifier is deliberately partial. After the protected/public
input files and all `RC6_RECOVERY_*` image, volume, identity, route and secret-file environment
variables required by `deep-devops/docker-compose.rc6-application-recovery.yml` are set, run this
exact command from the repository root:

```powershell
node ./deep-devops/scripts/rc6-application-recovery-verifier.mjs `
  --compose-file ./deep-devops/docker-compose.rc6-application-recovery.yml `
  --project-name rc6-recovery-drill `
  --expectations '<public-expectations.json>' `
  --evidence '<evidence-root>/application-services-recovery.json'
```

A successful result from this scaffold reports `partialApplicationServicesValidated=true`,
`applicationContourValidated=false`, and
`scope=isolated-restored-application-services-partial`. It validates the restored
registry/storage/file/push/calls-v2 service subset across a bounded restart. It does **not** validate
restored XNode identity, privacy routing or TURN; these remain listed in `unvalidated` and must be
proved separately before the full application contour or release drill can be marked complete.

Record only pass/fail, bounded counts and canary hashes for these checks:

- XNode returns the same pre-drill public identity fingerprints derived from the protected Ed25519,
  X25519 and BLS material, accepts the signed route authority, and retrieves the pre-drill storage
  canary;
- registry restores membership/projection counters and durable call state; a pre-drill pending
  encrypted signal is drained exactly once and replaying the same signed nonce is rejected;
- storage retrieves the exact canary hash, file service returns the exact encrypted fixture hash,
  and push subscription counts match without contacting a real provider;
- TURN and registry resolve the same protected shared-secret version, while unsigned signaling,
  inbox and ICE requests remain `401` and call readiness is fail-closed when the secret is absent;
- restart the isolated stack once more and repeat the probes to exclude a first-boot-only success.

Any missing state, changed identity fingerprint, accepted replay, schema fallback, permissive TLS or
provider side effect is a failed drill.

## Rollback contract

Rollback changes code/configuration and state as one pinned unit:

1. stop and preserve the failed candidate diagnostics without placing raw output in evidence;
2. quiesce writers and snapshot the failed candidate state before changing it;
3. select the previous release by immutable manifest and image digests;
4. if state compatibility is explicitly proven, start the previous images against a cloned state
   volume; otherwise restore the pre-upgrade snapshot into new volumes and never let old code mutate
   upgraded state;
5. restore the matching protected-material versions and signed authority generation;
6. run readiness, negative authentication, canary retrieval, call replay and restart checks;
7. switch traffic only after all checks pass, then retain both snapshots until the observation window
   and recovery objective are met.

Do not use a legacy reader, migration fallback, empty volume or regenerated identity to make rollback
green. If the previous release cannot safely read the candidate schema and no pre-upgrade snapshot is
available, the correct result is `No-Go`.

## Apple lane

The RC release authority covers Android and Windows. iOS, iPadOS and Mac Catalyst remain explicitly
unverified and non-blocking for this RC until a designated macOS build/signing authority and physical
Apple-device evidence exist. Those platforms must not be advertised as release-supported merely
because their target frameworks compile.

## Documentation toolchain

`xpoint-docs` pins Node.js 24.13.0, npm 11.8.0 and `marked` 18.0.11 with an npm
lockfile. The repository-owned static renderer emits no client JavaScript,
escapes raw HTML and adds a restrictive CSP. HonKit and its vulnerable
Immutable.js 3.x dependency were removed rather than overridden. The complete
two-package development graph must pass `npm audit --audit-level=high`; package
install runs with lifecycle scripts disabled.

## Evidence acceptance

The RC evidence manifest may include only the drill schema version, pinned tool/image digests,
timestamps, duration, result booleans, bounded counters and SHA-256 values. Reject absolute paths,
volume/container/project names, hostnames, account/device/node identifiers, request/response bodies,
credentials, stdout/stderr and raw logs. Backup archives and protected-material inventories stay in
the protected backup system and are referenced only by non-secret version/checksum records.
