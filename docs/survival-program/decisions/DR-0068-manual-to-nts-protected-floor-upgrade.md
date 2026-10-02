# DR-0068 — explicit manual-to-NTS protected floor upgrade

Status: accepted operator implementation; production activation gated
Date: 2026-10-02
Decision owner: Mr. X (delegated architecture authority)

An initialized DID2 Registry may acquire its first automatic NTS lower floor
without re-provisioning ADA2 or changing genesis, node keys, head floors,
witness custody or nonce ledgers. This is an explicit operator transition,
not an automatic missing-floor repair, account migration or new time source.
It changes no wire formats or signed authority.

Require the exact retained manual-anchor SHA-256, authenticate its HMAC,
canonical CRT1/network/interval and verified pinned XNA1/DTS1 lineage. Carry
only the persisted manual interval's historical lower bound. Do not infer boot
continuity from uptime; do not import its upper bound or extrapolate its age.
The signed authority/policy not-before is an acceptance constraint, not fresh
time. The initial NTF1 lower bound is the maximum of these lower constraints.
No old interval, OS/HTTP clock or artifact validity authorizes a new proof.

Hold both manual and target leases; reject aliasing/link paths and any existing
target floor before mutation. Stage the exact protected initial NTF1 using
CreateNew, then durably create an integrity-protected one-time transition fence
binding network, retained manual hash and staged NTF1 hash. Flush and compare
both exact files before non-overwriting activation by rename. Manual custody
remains byte-identical. No pending stage may activate the automatic runtime.

An interrupted transition can resume only the same authenticated pending
bytes and fence under the same manual CAS. Once activation removes the pending
stage, a retained fence plus missing floor is custody loss: reject; restore the
current retained floor, never recreate its older initial value. Existing or
advanced floors cannot be reinitialized by this action. Preserve fence with
floor through backups and upgrades. This remains file-backed integrity, not a
hardware monotonic counter or proof against joint rollback of all custody.

After activation every runtime boot must acquire a new upper interval from
the exact signed DTS1 authenticated sources/family quorum, intersect with the
retained lower floor and durably persist it before use. Until then readiness
stays unavailable. Expired signed policy/operational inputs and directory heads
still require their independently authorized successors; this command does
not extend expiry or establish device delivery.
