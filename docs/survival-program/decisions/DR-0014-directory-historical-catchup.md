# DR-0014 — bounded historical DID2 catch-up

Status: accepted candidate API and transport; runtime/release gates remain open
Date: 2026-09-29
Decision owner: Mr. X (delegated pre-production clean-break authority)

An offline account must not discard its protected floor or require a new
offline-root checkpoint merely because more than 64 heads were published.

The separately frozen API is
`DeepIdV2DirectoryCatchupVerifier.Verify(VerifiedXPointNetworkAuthority,
AccountDirectoryProtectedLkg, IReadOnlyList<ReadOnlyMemory<byte>>,
ReadOnlyMemory<byte>): VerifiedDeepIdV2DirectoryCatchup`.
Its page contains 1..64 exact canonical ADH1 successors, each at most 4,096
bytes, and at most 64 concatenated 32-byte RFC6962 consistency nodes. Input
bytes are copied before verification. Every head is threshold-authenticated
against the verified XNA1 lineage, requires reader 2, increments generation
by exactly one and consumes the preceding core hash. Tree sizes cannot
decrease; equal sizes retain both roots. A consistency proof must bind the
page endpoint to the exact protected source append-log root.

The sealed result has no public constructor, contains `PriorProtectedLkg`
and `ProtectedLkg`, and grants historical floor advancement only. Expiry is
not a reason to erase history. It contains no DTT1, current-time assertion,
account binding, placement, route, signing or message capability. Persistent
consumers must CAS against its exact prior floor, flush and reauthenticate
the committed endpoint before fetching the next page. Current operations
still require a new nonce-bound DTT1/current-value proof at the caught-up floor.

The closed candidate transport is frozen in the directory normative owner:
DHQ2/DHR2, version 2, `/api/v2/account-directory/history`. It carries only
public authenticated history. Global release activation remains a separate
gate; adding this transport does not activate other TARGET_UNFROZEN records.
Existing bytes, hashes, signatures and stored floors remain unchanged. Public
API snapshots and consumers require source/package repinning, not a reset.

The real Docker admission load exposed repeated full sparse-map rebuilds and
complete query-proof construction for every historical prefix. The accepted
candidate API `DeepIdV2DirectoryProofMaterialAuthor.ValidateCompleteJournalHistory`
checks every authenticated head's exact append/map prefix and ordered
checkpoint-prefix set in a single complete journal replay. It grants no raw
head authentication or freshness. Incremental sparse-map path updates use the
same existing domains/hashes; independent full-rebuild comparisons, changed
intermediate roots and shuffled cross-prefix checkpoints must still reject.
Batch-internal checkpoint set ordering remains unchanged. This is an
implementation/performance change, not new transition or proof bytes.

Normative owner: [directory architecture](../../architecture/ACCOUNT-DIRECTORY-TRANSPARENCY-V1.md).
