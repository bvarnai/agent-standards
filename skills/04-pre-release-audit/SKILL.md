---
name: 04-pre-release-audit
description: Execute a read-only pre-release readiness audit checking git status, test suite results, changelog completeness, and spec compliance. Activate before tagging a release or running /04-pre-release-audit.
metadata:
  lifecycle_stage: "04-pre-release"
  mode: "one-shot"
  recommended_flags: "--effort high"
---

# 04 — Pre-Release Audit

## Constraints & Domain Rules
1. **Strictly Read-Only**: This skill performs inspection and audit only. Do not mutate git state, create tags, or edit files during this phase.
2. Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
3. Inspect `CWD` and consult [stack-routing.md](../../fragments/stack-routing.md) to run the appropriate build and test verification commands.

## Audit Checklist (Target Workspace CWD)
1. **Working Tree Hygiene**:
   - Verify `git status` has no uncommitted changes or untracked build artifacts.
   - Verify current branch matches the intended release branch (e.g. `main` or `release/*`).
2. **Automated Verification**:
   - Execute the full test suite with race detection / memory checks enabled.
   - Run linters and static analysis to confirm zero warnings or errors.
3. **Spec Alignment & Drift**:
   - Verify all features merged since the previous release tag correspond to an approved specification in `docs/spec/` or a closed Git issue.
4. **Documentation & Changelog**:
   - Check `CHANGELOG.md` for unreleased entries summarizing all breaking changes, new features, and bug fixes.
   - Check that version references in `README.md`, build scripts (`pom.xml`, `version.go`, etc.) are ready for the target bump.

## Output Contract
Return a concise audit matrix:

| Checkpoint | Status | Details / Findings |
| :--- | :--- | :--- |
| Clean Git Tree | Pass / Fail | ... |
| Full Test Suite | Pass / Fail | ... |
| Static Analysis / Linter | Pass / Fail | ... |
| Changelog Completeness | Pass / Fail | ... |
| Release Readiness Verdict | **GO** / **NO-GO** | Blockers or release approval summary |
