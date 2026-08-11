# Sprint 01 — clean-break foundation tasks

## DNP1-GOV

- [ ] activate `v3.0.0` in the central source-of-truth pointer;
- [ ] update the governance checker to verify the new manifest and DR-0003;
- [ ] verify the exact document-set digest and all local links;
- [ ] confirm child repository statuses are unchanged;
- [ ] locally commit only the governance scope; no push.

## DNP1-INV

- [ ] capture exact repository HEAD/status and existing residuals;
- [ ] inventory production source, generated code, packages, tests, docs,
  Docker/runtime services and public/signed/database contracts;
- [ ] classify every item as retain/remove/redesign/reference-only;
- [ ] identify native replacements for peer origin, file/avatar and push;
- [ ] identify all `SessionId`-coupled models that require redesign rather than
  blind deletion;
- [ ] freeze exact last-compatible source/package identities;
- [ ] specify forbidden production-reference and no-downgrade gates;
- [ ] inventory current recovery entropy/wordlist/KDF and every role derived
  from Session identity material;
- [ ] inventory available maintained ML-KEM/ML-DSA providers on every target
  platform without selecting or implementing one;
- [ ] review inventory and deletion order for P0/P1 findings;
- [ ] do not begin Wave 1 code until the inventory verdict is GO.

## Exit evidence

- governance checker output;
- document-set SHA-256;
- exact changed-file scope and local commit;
- inventory counts by repository/classification;
- unresolved replacement dependencies and owners;
- formal GO/NO-GO for Wave 1.
- exact inputs and blockers for `DNP1-SPEC-crypto`.
