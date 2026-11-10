---
name: 04-pre-release-audit
description: Execute a strict, read-only pre-release readiness audit across code, specifications, user documentation, test suites, and CI/release pipelines to identify P0 blockers and technical debt. Activate before tagging a release or running /04-pre-release-audit.
metadata:
  lifecycle_stage: "04-pre-release"
  mode: "one-shot"
  recommended_flags: "--effort high"
---

# 04 — Pre-Release Audit

## Constraints & Role
1. **Strictly Read-Only**: Perform inspection, static analysis, and test execution only. Do not mutate git state, create tags, or edit files during this phase.
2. **Tone & Signal**: Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md). **Do not summarize what is already working well**—report only concrete findings, drift, and actionable fixes.
3. **Stack Verification**: Inspect `CWD` and consult [stack-routing.md](../../fragments/stack-routing.md) to execute the stack's automated test suite and static analysis commands.

## Audit Scope & Evaluation Criteria

### 1. Working Tree, Build & Test Verification
- Verify `git status` is clean (no uncommitted modifications or untracked build artifacts) and the active branch is the intended release target.
- Execute the full automated test suite (with race detection / memory checks enabled) and static analysis/linters (`go vet`, `shellcheck`, compiler warnings).

### 2. Cross-Artifact Consistency (Spec $\leftrightarrow$ Code $\leftrightarrow$ Docs $\leftrightarrow$ CI)
- Cross-reference CLI flags, environment variables, configuration schemas, exit codes, and public signatures in the source code against `docs/spec/`, `README.md`, and `docs/user-guide/`.
- Verify version strings, dependency matrices, and minimum runtime/compiler versions across build manifests (`go.mod`, `pom.xml`, `CMakeLists.txt`), `.github/workflows/`, and documentation.
- Flag deprecated features, dead references, or behavioral drift between documented examples and actual code paths.

### 3. Documentation Depth & Operational Readiness
- Evaluate whether architectural invariants, edge cases, failure modes, and concurrency/performance constraints are documented with sufficient technical rigor.
- Identify **"happy-path bias"** where error handling, exit codes, recovery procedures, or platform-specific limitations (Linux/WSL vs. Windows) are omitted.
- Check operational onboarding: reproducible build instructions, local development setup, and dependency prerequisites.

### 4. Release Governance, Artifacts & CI/CD Pipelines
- Verify the presence and completeness of standard repository and release files: `LICENSE`, `CHANGELOG.md` (with unreleased changes cataloged), `CONTRIBUTING.md`, `.gitignore`, and `.gitattributes`.
- Audit CI/CD and release workflows (`.github/workflows/ci.yml`, `release.yml`, package manager publishers): automated test/lint gates, cross-platform artifact compilation, checksum generation, and badge/telemetry accuracy.
- Identify gaps in structured logging, diagnostic output (`stderr` prefixes/hints), or observability needed for production troubleshooting.

## Output Contract
Produce a concise, actionable audit report containing:

1. **Verification Checkpoint Summary**:
   | Checkpoint | Status | Details |
   | :--- | :--- | :--- |
   | Working Tree Hygiene | Pass / Fail | ... |
   | Automated Test Suite & Linter | Pass / Fail | ... |
   | Spec $\leftrightarrow$ Code $\leftrightarrow$ Docs Alignment | Pass / Fail | ... |
   | Release & CI Artifacts | Pass / Fail | ... |
   | **Release Readiness Verdict** | **GO** / **NO-GO** | **NO-GO** if any `P0` blocker exists |

2. **Prioritized Findings** (Omit empty tiers):
   - **Release Blockers (`P0`):** Failing tests, critical spec/code/doc inconsistencies, broken build/release instructions, or missing legal/release artifacts that must be fixed before tagging.
   - **Technical & Documentation Debt (`P1`):** Undocumented edge cases/failure modes, happy-path bias, or fragile configurations.
   - **Polish & Governance (`P2`):** Minor drift, community template gaps, or diagnostic/metric improvements.

3. **Remediation Matrix**:
   | Priority | Finding | File / Artifact | Concrete Fix |
   | :--- | :--- | :--- | :--- |
   | `P0` / `P1` / `P2` | ... | `path/to/file` | Exact change required |
