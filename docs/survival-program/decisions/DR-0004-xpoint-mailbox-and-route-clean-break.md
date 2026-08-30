# DR-0004: XPoint mailbox and route authority clean break

Status: **accepted**  
Date: 2026-08-30  
Owner: XPointLabs architecture

## Decision

The first public generation rejects pre-cutover `PMA1/PMT1/PMS1`,
`PRA1/PSS1` and `RCD1/RDA1/RCR1/RHC1/RTC1/RCA1/PRA2/PSS2` as runtime wire.
Their reviewed deterministic placement, continuity, replay, CAS and recovery
properties may be ported, but their authority graph and bytes are not retained.

The only target mailbox/route graph is acyclic:

```text
XNA1 authority
  -> XND1 descriptor cores
  -> PMA2 mailbox-directory threshold authority
  -> XNV1 global view
       -> PMT2 exact mailbox projection bound to XNV1
       -> XCB1 carrier bindings
       -> XCD1 CallRelay cores
  -> PMS2 deterministic blinded selection under PMT2
  -> XRA1 owner reachability authorization
  -> XRC1 short-lived live route closure
  -> XRR1 contact/invite reachability reference
  -> XSS1 retained successor/checkpoint proof
```

`PMA2` authorizes the mailbox-directory threshold and algorithm, never a user
route. `PMT2` binds exact XNV1 and all eligible Mailbox-role descriptor cores.
`PMS2` is deterministic `Rendezvous-SHA256-v2` selection over a random blinded
input. A Registry response cannot override any ranking or signature.

`XRA1` is recipient-authored and contains network, random scope/capability,
allowed operation classes, maximum quota, exact DMD1/ADC1 head, authorized
directory-threshold key set, generation/predecessor, issued/expiry and device
signature. It lasts at most 400 days and contains no account-derived placement.

`XRC1` is directory-threshold signed, lasts at most 24 hours and binds exact
XRA1, XNV1, PMT2, PMS2, replica capabilities, onion traffic-key epochs,
generation/predecessor, validity and next-closure commitment. The threshold may
refresh it while the recipient is offline only within XRA1 scope. It cannot
change identity, devices, quota class or operation class.

`XSS1` is the hash-closed retained successor/checkpoint package for XRC1. It is
stored for 400 days and at least 1,024 generations. Same-generation changed
bytes or inconsistent XNV/PMT/PMS input fail closed and produce fork evidence.

`XRR1` is the recipient-shared reachability record and references exact XRA1,
current XRC1 and XSS1 head. Reusable DCB1 contains XIR1; resolve returns current
XRR1 closure. Established contacts receive successors through XUR1.

## Consequences

- There is one mailbox source of truth: XNV1-bound PMT2 plus deterministic PMS2.
- Offline route refresh does not require a device to sign daily network state.
- The delegated threshold cannot redirect to nodes outside exact PMT2 or extend
  recipient authorization.
- Old production-mailbox specs remain historical implementation evidence and
  are marked pre-cutover; they are not normative target inputs.
- Exact schemas, domains and vectors for all records above are one M0 freeze
  package. There is no migration, dual reader or compatibility alias.

