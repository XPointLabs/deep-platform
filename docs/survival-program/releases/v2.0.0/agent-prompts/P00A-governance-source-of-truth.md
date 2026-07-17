# P00A — Governance source-of-truth activation

## Role/repository

You are the program DRI. Work only in the `C:\Work\DeepSession\XPointLabs` superproject repository named in `TARGET_REPOSITORY`. Do not edit any child repository.

## Objective

Make the approved program revision discoverable and authoritative through the existing `prompts/00_Agent_Entry_Point.md`, roadmap and delivery-plan chain.

## Preflight

Verify `BASE_SHA`, clean/assigned worktree, `PROGRAM_REVISION_SHA` and named CEO/CTO/DRI decision record. Stop if the revised program is not approved or its authoritative versioned location has not been chosen.

## In scope

- mirror or move the approved program into a versioned superproject path without changing its content silently;
- update entry point/roadmap/delivery-plan precedence and status;
- record DRI, decision owners, Horizon A scope/deferred scope and approval date;
- define manifest schema location, program revision hash and work-package ID namespace;
- record an approved contract packaging policy: PackageId/package split, SemVer rules, local immutable artifact directory, SHA256 and prohibition on external publish without separate authority;
- document that broad legacy sprint prompts are backlog only;
- add a link/check test that fails if the referenced program revision is missing.

## Out of scope

Child-repo code, CI implementation, runtime, merge/deploy and filling CEO resource fields without authority.

## Acceptance

An agent following current `AGENTS.md` reaches one non-conflicting program revision; old roadmap items clearly state superseded/deferred status; program hash is reproducible; no child repo is modified.

## Verification/handoff

Run superproject documentation/link checks. Write standard artifacts and unblock P00B/P01/P02 only.
