# Deep Native Protocol v3 work packages

Use only bounded work packages matching:

```regex
^DNP1-(?:GOV|INV|SPEC|PROTO|CLIENT|NODE|OPS|SEC)(?:-[a-z0-9]+)*$
```

Initial executable packages:

- [`DNP1-GOV`](DNP1-GOV.md) — activate the source of truth and machine gates;
- [`DNP1-INV`](DNP1-INV.md) — cross-repository retain/remove/redesign inventory.

The first specification package is
[`DNP1-SPEC-crypto`](DNP1-SPEC-crypto.md), but it remains blocked until the
inventory verdict is GO.

Later packages require accepted Wave 1 specifications. Do not infer permission
to delete code, reset state, package, repin, deploy or publish from a planning
document.

Every implementation package must state one repository owner, exact base SHA,
exact file scope, tests, consumer impact, rollback/reset behavior and explicit
P0/P1 review verdict.
