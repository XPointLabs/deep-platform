# DID2 initial ADF1 offline ceremony

This procedure is for the first root-authorized forward checkpoint from the
separately pinned, signed empty DID2 directory head. It does not sign every
admission and does not replace the later periodic covered-set/checkpoint policy.
The offline root seed remains outside Registry and XNode containers.

1. Stop admissions on the isolated candidate and retain its ADA2 state. Read
   the exact latest-head row from the independent floor with a read-only role.
   Record its ADH1 core hash and exact head bytes separately from the ADA2
   backup. Never derive the *expected floor hash* from ADA2 itself.
2. On the isolated operator host, run
   `did2-directory export-current-head <floor-core-hash> <new-output.adh1>`
   using configuration pointing to the copied HMAC-protected ADA2, its
   integrity key, signed XNA1/DTS1 chain, and pinned DID2 genesis. The command
   replays the full signed-head/PQ-admission journal and refuses a mismatched
   independent floor. It creates a new output file; it never edits ADA2.
3. Review the exported generation, tree size, core hash, target validity
   interval, source genesis pin, network/XNA1 pin, and custody manifest. If the
   target ADH1 has expired, do **not** backdate the root signature or attach a
   fresh DTT1 to that historical head. With admissions stopped, run the
   candidate's `did2-directory refresh-current-head <valid-from-unix>
   <valid-until-unix>` operator action using its exact witness custody and
   independent PostgreSQL floor. It permits only a near-current one-hour
   interval and appends a new witness-signed ADH1 successor without changing
   the journal, tree size or map root. It advances the external floor by CAS;
   if ADA2 persistence then fails, stop and recover rather than resetting the
   floor. Re-read the floor independently and repeat step 2 for the new head.
4. In offline root custody, run `Did2Adf1Offline` with exactly these inputs:
   `--authority-root`, `--output`, `--xna1-core-hash`, `--xna1`, `--dts1`,
   `--source-adh1`, `--source-adh1-core-hash`, `--target-adh1`,
   `--target-adh1-core-hash`, `--issued-at-unix`, and `--minimum-reader 2`.
   The source must be the verified empty DID2 genesis; the target must be a
   newer signed nonempty head. The issue time must be within five minutes of
   the offline machine's current UTC and inside target/authority validity.
   The tool compares the root seed to the custody manifest and the manifest
   to the verified XNA1 before signing. Output must be a new file under the
   offline authority artifacts directory.
5. Independently decode and verify the exact ADF1, record its SHA-256, then
   copy **only** the signed public artifact to the candidate Registry. Configure
   the ordered `ForwardCheckpointPaths` import. The Registry has no root
   private key and must refuse a non-successor without the imported artifact.
6. Resume isolated admission/proof checks against the retained latest-head
   floor. Verify an older protected client floor catches up through AFP1 and
   an exact signed ADH1 successor tail to the latest DTT1-bound head. Check
   rollback, wrong source, changed ADF1, historical DTT1, and wrong DID2
   negatives before any public cutover or device E2E claim.

For the initial release, production still starts with three XNodes. None of
these steps authorizes a GitHub Release or a merge to `main`.
