# RC-6 release-candidate commit matrix

The canonical input is `docs/release-candidate-commit-matrix.v1.json`. It contains exactly the
seven repositories required by the RC-6 cross-repository gate and one exact lowercase 40-hex
commit for each repository. Missing, duplicate, reordered or additional entries are rejected.

## Two-step binding model

The manifest deliberately does not contain a superproject commit. A file cannot truthfully name
the commit that will first contain that file without a circular, unstable self-reference.

Use this two-step model after all child changes have been committed:

1. Run `scripts/New-Rc6ReleaseCandidateCommitMatrix.ps1`. It refuses dirty child repositories and
   writes their exact HEAD commits. Stage the seven required gitlinks and the manifest, then run
   `scripts/Test-Rc6ReleaseCandidateCommitMatrix.ps1 -Mode Prepare`. Prepare accepts only those
   staged paths, requires no unstaged or untracked root files, and proves that manifest, index
   gitlinks and clean child HEADs agree.
2. Commit the prepared superproject state. With root and children clean, run
   `scripts/Test-Rc6ReleaseCandidateCommitMatrix.ps1 -Mode Verify -EvidencePath <path>`. The
   evidence path must be outside the superproject. Verify binds the manifest to the containing
   commit by checking the commit tree, index and child HEAD for every required gitlink.

The post-commit evidence records the observed superproject commit and SHA-256 of the exact manifest
bytes. That evidence is an output, not a tracked input, so it closes the binding without pretending
that the manifest knew its future containing commit.

## Evidence boundary

Evidence is bounded to 8 KiB and has a closed schema. It contains only the release commits,
manifest digest, fixed status values and aggregate checks. Absolute paths, command stdout/stderr,
hostnames, usernames, device identifiers and other private identifiers are not emitted.
