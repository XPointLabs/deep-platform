# DNP1-GOV — activate Deep-native clean-break governance

## Objective

Make `v3.0.0` the single discoverable active program without modifying child
repository production code.

## In scope

- active-release pointer and program manifest;
- reproducible document-set digest;
- source-of-truth/link checker update;
- DR-0003 linkage;
- work-package namespace and first-sprint boundary.

## Out of scope

- child repository code or packages;
- Session source deletion;
- state reset, Docker rebuild, deployment or publication;
- cryptographic protocol selection.

## Acceptance

- one active SemVer program is discoverable from the workspace entry point;
- manifest schema and digest verify;
- v2 remains immutable and reachable as evidence;
- DR-0001 local-only/no-push policy and DR-0003 clean-break decision are both
  explicit;
- no child repository status changes are introduced.

