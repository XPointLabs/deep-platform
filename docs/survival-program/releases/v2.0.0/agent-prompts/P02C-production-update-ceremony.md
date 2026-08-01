# P02C — Production-like update key ceremony and release pipeline

## Role/repository

Work only in `deep-devops` after P02 ADR approval. This task requires explicit authorization and named custodians; otherwise perform a dry-run with ceremony-grade test keys.

## Objective

Operationalize root/targets/snapshot/timestamp metadata, mirrors and rotation/revocation drills for the closed Beta.

## In scope

- documented multi-person root ceremony and offline/HSM custody interfaces;
- delegated online release roles and CI request boundary;
- metadata generation/signing/publication to at least two mirrors plus offline bundle;
- SBOM/reproducible artifact/hash evidence;
- rotation, lost-online-key, mirror compromise and rollback/freeze drills;
- handoff to P02B verifier.

## Out of scope

Printing/importing secrets into ordinary CI, silent app install, store submission and bypassing platform signatures.

## Acceptance

No root key enters CI/artifacts; required thresholds are evidenced; production-like signer set passes drills; mirrors publish byte-identical content-addressed metadata; P02B fixtures verify it.

