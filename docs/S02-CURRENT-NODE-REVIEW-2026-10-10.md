# S02 current node admission: requirement-to-evidence review

Date: 2026-10-10. Owner: Mr. X. Scope: the S02 source/composition stage in
[the sole execution plan](architecture/IMPLEMENTATION-PLAN-V1.md#s02--current-xnode-client-admission).
Status: **S02 source/composition stage accepted** on matching full and transport evidence.
Production activation, shipping and physical delivery are not accepted by this review.
Accepted Node commit: `5c96043b3cc423285957d42ac0aa4ccd494494a4`, pushed to
`release-candidate/prod-20260909` with the remote SHA independently checked.
Current status and subsequent stages remain in [NEXT-SPRINT](NEXT-SPRINT.md).

This is an evidence mapping, not a second protocol specification. Exact grant,
selector, holder and authority semantics remain with DR-0080/0081/0083 and the
[protocol registry](architecture/PROTOCOL-REGISTRY-V1.md).

## Requirement mapping

| S02 requirement | Actual implementation and executable proof |
| --- | --- |
| One current-only Program/DI graph; no PMA1/P04 fallback | `Program` rejects retired configuration and calls `AddCurrentMailboxHost`. Composition refuses split owners, requires current source/clock, and uses rejecting generic authority/revocation plus `NoWallClock`. `CurrentMailboxHostCompositionTests` checks retired compiled types/configuration, disabled composition, missing source and duplicate owners. |
| Store/Retrieve/ACK through actual configured sources, selected exit and native owners | `ConfiguredProgramSourcesEnrollRecoverAndCompleteStoreRetrieveAckOverPinnedHttp` acquires actual HTTPS directory/MGR inputs, explicitly enrolls, exercises public signed HTTPS/H2 onion ingress and peer HTTPS, cold-reopens and retries exact requests. Wrong selected Store writer preserves all three native mailbox roots. |
| Distinct node IDs and descriptor signing keys | Configured fixture and `DistinctDescriptorKeysCompleteStorePaginationAckAndExactRecovery` use independent IDs/keys; `HostSigningCustodyMismatchRejectsAllClientOperationsBeforeReplay` covers all three client operations. The HTTP onion authenticator resolves XND1 keys rather than treating IDs as keys. |
| Profile1/MAU2, wrong selector/role/body/member reject before replay/mutation | Six cases of `NativeIngressAdmissionBoundaryPreservesBothOwnersAndOriginalRequest`; current Protocol producer rejects raw profile1 before signature checking. The nonmember grant is genuinely issuer/holder-signed. Both native data roots remain identical, no HTTP/intent/outcome/mutation occurs, and the original signed counter/body still succeeds. |
| Wrong holder | Three operations in `NativeIngressWrongHolderRejectsBeforeReplayOrIntent`; shared admission also checks holder before replay/time-floor reservation. |
| Protected time, expiry boundary, rollback and revocation | Three `NativeIngressAuthorityFenceRejectsBeforeEitherReplayOrMutation` cases use the exact trusted-upper expiry boundary, monotonic rollback and signed MGR serial revocation. Host admission holds both protected role owners and rechecks the exact current source/descriptor selection at every lease check; it does not use host UTC or caller time. |
| Callback crossing expiry releases no successful receipt | `NativeIngressExpiryInsidePeerCallbackSuppressesSuccessAndKeepsExactPending` returns unknown rather than success and preserves the exact pending intent for cold retry. Source/custody callback refusals also exist in admission and receiver suites. |
| Honest unready, intact custody and independent client replay rollback fence | `CurrentHostRecoveryLostDocumentOrProtectionStaysUnreadyWithoutEnrollment` and native recovery tests reject loss of replay+outcomes together, authentic older counter state, Pending restored after completion, and Retrieve-only state loss. Protected operation custody is independent of those native replay/outcome files; recovery never reenrolls or repairs them silently. |
| Retained client admission after original projection expiry | `NativeIngressRetainedReadAndAckKeepOriginalEpochAcrossProjectionAdvanceAndColdHttpRetry` advances genuine signed PMT/directory evidence and both role floors on both nodes, uses a current Retrieve grant for the original epoch, verifies original intent commitment, lost ACK/cold exact peer HTTPS retry, tombstones and a fresh empty read. Expired original Store stays rejected. |

The retained ACK scenario exposed and fixes a concrete coordinator defect:
the intent previously used the current host commitment while its peer request
used the original grant commitment. They now both use the verified grant's
original commitment; current host/time/revocation and protected owners still
authorize every operation. No migration, extra journal, wire change or weaker
assertion is introduced.

## Qualification and limits

Detailed commands, terminal receipts, hashes and preserved failures are in the
[Node checkpoint](../xnode/docs/testing/s02-current-consumer-2026-10-10.md).
New matching focused10/0/0 and whole unit255/0/0 have native0/build0 and no
warnings. Common receipt inspection confirms all255 previous unit cases with
exactly one reviewed MAU3 name correction, no other missing stable case key.
The twelve named groups above contain24 cases; common receipt inspection now
confirms all24 in the accepted matching full, not just reference membership.

`node-current-boundaries-full-01` uses the prior qualified Integration/Profile
receipts plus the new whole-unit and boundary receipts. No FAIL/skip exemptions
or rewritten historical receipts are used. Its terminal at
`2026-10-10T13:06:07.5222342Z` records all exits0 and FullAccepted=true:
1441/0/0, exact1441 cases and2136 unchanged inputs. Fresh external/no-mock smoke
and three-node rehearsal both finished native0 on this source. Smoke has no
hard/soft failures or runtime warnings; rehearsal has three distinct real Xray
nodes, Registry count3 and reconciliation issues0. Exact receipt hashes and
cleanup evidence are in the Node checkpoint. Expected unauthorised privacy503
in rehearsal is not messaging evidence. This closes S02 source/composition,
not production activation or any later stage.

Configured integration uses test-owned signed authority, a fixture monotonic
clock, loopback TLS trust and a test-only HTTPS/H2 ingress proxy; Xray is disabled
in that configured fixture. Independent no-mock transport gates do not turn it
into installed/physical evidence. Retained client ingress is a native dispatcher
plus genuine peer HTTPS scenario, not configured public H2.

Coordinated peer replay/mutation/blob loss is not independently anchored by the
client replay floors and remains S03. Client lifecycle, issuer provisioning,
connected clients, shipping packages, physical Windows/Android text, files,
groups and the full release scope remain required at their following stages.
Physical contacts/messages/files/groups: **0/4 confirmed**. No production deploy,
GitHub Release or main merge is justified by this review.
