# DR-0127 — capped contact-object successor validity

Status: accepted semantic correction; matched source/runtime/device qualification remains
Date: 2026-10-16
Decision owner: Mr. X (delegated architecture authority)

The retained Android diagnostic reached DR-0076 object succession and rejected
`ContactSuccessorAdvance`. A real signed source regression reproduces the same
guard with the standard day-long initial prekey service and contact object,
followed by renewal of a shorter-lived route threshold. The new route advances,
but the unchanged prekey service caps both contact objects at the same expiry.
Requiring that expiry to increase makes ordinary route renewal impossible.

The sole semantic owner is [CONTACT-RESOLVER](../../architecture/CONTACT-RESOLVER-V1.md).
Supersede only DR-0076's strictly increasing DCB1 expiry requirement:
the successor's issue time and expiry must be nondecreasing. Equal expiry is
permitted; a smaller expiry is rejected. The DCB generation still increases by
exactly one and tag9 still binds the exact prior signed bundle hash. Identity,
service descriptors, profile, policy and permanent locator remain unchanged.

This does not extend any authority. The new object's expiry remains bounded by
its independently verified DCA1, XIR1 and every XPS1; the entire current trusted
time interval must still fit those signed bounds. Expired services/objects
remain unusable. XRA1 and threshold successor advancement rules are unchanged.
Prekey replenishment/service rollover remains a separate lifecycle operation,
not an implicit modification of existing keys or retained publication intent.

No wire bytes, suite, signature domain, public API, journal generation, slot,
limit, compatibility reader or reset is introduced. The same shared Protocol
lineage check must be rebuilt in owner and issuer consumers. Do not activate
only the client while the issuer still applies the preceding predicate.

Qualification requires the original failing source receipt, successful actual
signed owner-to-issuer renewal at equal service-capped expiry, exact same service
bytes, preserved predecessor/current custody and cold replay. Negative tests
retain smaller-expiry/issue-time, wrong predecessor, repeated/gapped/overflow
generation and changed scope refusal. Current expiry and signature checks stay
separate mandatory gates. Same-account physical retest, consumer graph/source
gates and deployment qualification remain open; this decision is not release
approval or proof that every observed physical refusal has the same cause.
