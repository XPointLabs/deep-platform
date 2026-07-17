# P00 — Superseded umbrella

Do not issue this prompt. It was split into `P00A-governance-source-of-truth.md` and `P00B-pinned-manifest-ci.md` to preserve the one-agent/one-repository rule.

## Role

You are the release/program infrastructure owner. Work only in the workspace governance location and `deep-devops` if explicitly authorized by `REPOSITORY`. Do not change messenger runtime code.

## Objective

Make the revised Survival Program an unambiguous source of truth and create a machine-readable manifest that pins compatible repository revisions for cross-repo CI.

## Authoritative inputs

- `C:\Work\DeepSession\docs\resilient-network-program\REVISED-PROGRAM-RU.md`
- `C:\Work\DeepSession\XPointLabs\prompts\00_Agent_Entry_Point.md`
- current `roadmap.md`, `docs/delivery-plan.md` and all applicable `AGENTS.md`
- mandatory invocation fields from `README.md`

## In scope

- record the Survival Beta scope, DRI, decision owners and deferred scope in the existing source-of-truth chain;
- define `integration-manifest.json` schema with repo URL, branch, exact SHA, contract/package version and evidence status;
- implement validation that rejects missing repos, floating refs and incompatible contract versions;
- define hot-file locks and machine-readable work-package status;
- add a CI lane that checks out manifest-pinned SHAs without changing normal repository CI;
- create report/evidence JSON schemas and an example manifest using current SHAs.

## Out of scope

Protocol, storage, client code, changing production branches, merging PRs, deployment and inventing new repositories.

## Acceptance

- an agent following `00_Agent_Entry_Point.md` reaches the revised program without conflict;
- manifest validation fails on a branch name where a SHA is required, an unavailable commit and incompatible contract version;
- example CI proves it checked out the exact expected SHA for every repo;
- docs identify DRI, repo owners, decision deadlines, legal/security reviewers and hardware dependencies;
- existing release gates remain fail-closed.

## Verification

Run the exact required checks in the touched `AGENTS.md`, including `node .\scripts\release-gate-contracts.mjs` and `node .\scripts\production-readiness-status.mjs` if `deep-devops` is touched. Record exit codes.

## Stop conditions

Stop if source-of-truth precedence requires a product-owner decision, a repo SHA is dirty/unknown, or a workflow would acquire write/deploy permission.

## Handoff

Write the required report. Name the manifest path/schema version and list which consumer prompts are unblocked.
