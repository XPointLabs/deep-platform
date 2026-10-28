# Safe pause — 2026-10-28

Work stopped at the owner's explicit request. This is an evidence/handoff
checkpoint, not a new execution plan or release acceptance. Resume only after
the owner asks. The execution queue remains [NEXT-SPRINT](../NEXT-SPRINT.md).

## Preserved state

- No Windows/Android or production changes in this slice. Local dev only.
- The same three CLI accounts, keys, native sessions and group remain retained;
  no resets and no re-authoring of rounds55–59. Cursor remains60.
- No new group message was authored. Delivery/fanout/ACK for a new round were
  not measured, and the ≤1s target remains unproved.
- Last completed local operator verification had nine healthy containers.
  Do not repeat build/renew/apply automatically on resume; first inspect current
  authority and the preserved receipts. The signed current publication's expiry
  recorded by the diagnostic was2026-10-29T17:36:09Z.
- Agents were stopped, with no test or CLI process intentionally left running.
  Existing Docker services remain as they were; no teardown or rollback.
- All checkpoint commits are local; this slice did not push or publish.

## Stable local commits and focused evidence

| Repository | Commit | Qualified scope |
| --- | --- | --- |
| Protocol | `482a1bc` | Historical signed network closure validation;176 focused tests |
| DevOps | `8e6abe8` | Same-source retained authority renewal and build-only historical validation;6 script +3 build-wiring tests,45 managed assertions |
| Shared | `764652a` | Pure authenticated archive builder;24 focused cases, no runtime activation |
| Shared | `e4dbf4f` | Recognize RouteRecovery as current-view coordination;5 passing cases in run01 plus corrected lease case in run05 |
| Root, before this checkpoint | `cb4a69b` | Accepted DR-0177 runtime/adoption contract and prior gitlinks |

Shared `e4dbf4f` accidentally has subject `zhigubigule`; the author is correct.
It is preserved without rewriting history. Its isolated-worktree cherry-pick is
`fb8a839`. CLI remains`8b247dd`, Registry`5e9ea01`, Node`28b7ef1`.

Receipts, relative to each repository:

- Protocol `artifacts/retained-policy-history-20261028-01/terminal.json`.
- DevOps `artifacts/retained-policy-build-20261028-01/terminal.json`.
- Shared `artifacts/p1-archive-builder-20261028-01/terminal.json`.
- Shared `artifacts/route-recovery-dispatch-20261028-01` through`05`.
  Runs02–04 contain fixture failures; preserve them. This is a qualified union
  of5+1 cases, not one six-case run or full acceptance.
- DevOps `artifacts/deep-dev-current-retained-renewal-20261028-02`.
  Build87252ms; Prepare5966ms; exact candidate validation1317ms;
  Apply120830ms; Up6139ms; Verify11061ms. Original identities, custody and
  signed prefixes retained. Run01 stopped before mutation on an observer bug
  that assumed exactly one group; actual retained group counts were2/11/1.
- CLI `artifacts/retained-storage-recovery-20261028-04`.
  Source-matched publish/primitive smoke passed. All three own publications
  completed; role2's exact phase1 recovery completed in40375ms.
  Maintenance stopped at command10/first connection cycle with NetworkVerify6.
  Total174744ms; failed command51549ms. All three custody checks passed,
  2937 inputs unchanged. No preflight/round followed.

Full source/package/release gates have not been qualified by these focused runs.

## Current blocker, established by authenticated read-only diagnostics

Role1 retains genuine completed publications0…6. Main native sessions retain
own route controls0…3; a historical session retains0. Every adjacent retained
XRA/XRC/XRR predecessor link matches the original committed chain. Latest6 is
supplied to the ordinary updater, which correctly requires the next adjacent
generation4 (or1). Publications4 and5 exist but have expired. All seven entries
are ordinary completed publications with no recorded-recovery origin.

Consequently this is neither a missing original nor a count7 recorded-winner
gap: private route catch-up must carry independently verified historical
completed transitions. Do not relax increments, backdate4/5, treat them as
current, reset native state, or manufacture a recorded-recovery witness.

Exact source path: Shared `ProtectedDeepIdV2AccountOwner.TextOutbox.cs` selects
the latest publication; Protocol `DeepIdV2ContactRouteUpdateVerifier` and
`DeepIdV2ContactRoutePredecessor` reject its non-adjacent transition.

Diagnostic evidence under CLI runtime04:

- `native-generation-diagnostic02/findings.md` and`receipt.json`;
- `publication-generation-diagnostic02/receipt.json` (links);
- `publication-generation-diagnostic03/receipt.json` (expiry/origin).

No backend writes occurred in those diagnostics. The first diagnostic's codec
failure remains preserved. An own native anchor is not new independent consent.

## Astra proposal: useful direction, NOT yet an accepted wire contract

Independently verify historical prefix pages, then separately qualify/promote
a current route. Maintain separate completed (XIR/XRR) and proposal (XRA/XRC)
cursors. Reuse original signatures, exact canonical request data, original DCA,
lookup, nonce/minimum ADH floor, original issuance authority and every adjacent
predicate. Current account/device/revocation/network/time admission is still
required per bounded call. Historical truth never grants live permission.

Completed atom upper bound28588 bytes, recorded atom16311; a closed header
≤1024 plus length field fits one legal atom under32768. Up to three atoms may
fit per call; three must not become a lifetime limit. No new crypto/service.
Owner, Registry and recipient each need their own authenticated progress.

Existing route reintroduction can transport typed proof controls using fresh
public endpoints and actual native relationship/consent. Store success does
not prove recipient prefix admission. Missing prerequisites/reordering need
staging; genuine conflicting generation/hash remains sticky. Current P1 replay
cannot promote historical kind14 pages indiscriminately.

Possible archive families7/8 and an immutable historical-evidence receive
outcome were proposed, but are not allocated or implemented. Do not code them
as normative merely because they appear here.

Resolve these three review gaps before accepting the contract:

1. Sender promotes6, receiver sees it after expiry and retains live3 plus
   verified historical6. A later7 names6 as predecessor. Requiring the
   receiver's last live3 as the sole predecessor deadlocks. Define the exact
   independently verified historical-endpoint rule or real semantic receipt;
   Store ACK is not that receipt, and6 must not be invented as previously live.
2. A final page can arrive before its prefix. After catch-up it needs fresh
   current qualification. Define an authenticated durable promotion fact so
   cold/full replay reproduces that qualification. An immutable historical
   receive outcome cannot simply be rewritten, and a SQL flag is not authority.
3. Ordinary completed controls may reorder too. Close causal staging, overlap,
   page-position and expiry cases; do not classify a legitimate gap as a fork.

HIGH2 remains open even after private catch-up until owner/Registry recorded
progress and XPS lineage have independent bounded checkpoints.

## Isolated incomplete P1 implementation

Checkpoint commit `8a399e83aac7b29a0109e06b592a7bf91bbc4587` on branch
`wip/p1-archive-runtime-20261028` in the separate manual Git worktree
`../.worktrees/p1/deep-client-shared` relative to this repository root.
Its tracked `WIP-HANDOFF-20261028.md` records file ownership, draft interfaces,
source-guard framing and remaining tests. `WIP-FULL-AUDIT-20261028.md` preserves
the constant-memory audit equivalence outline.

This code is unbuilt, unqualified and not active in retained CLI. Do not merge
it into the stable checkout as if it passed. The dependency Protocol worktree
is detached at482a1bc; the parent worktree docs junction points to this root's
docs. Preserve worktrees and original failed receipts.

The audit is not fully resolved: HIGH1 archive scans and HIGH2 sustained
recovery remain open; repeated admission is partial; cleanup is qualified only
for the earlier limited storage slice. Continue from these exact facts after
the owner's resume instruction.
