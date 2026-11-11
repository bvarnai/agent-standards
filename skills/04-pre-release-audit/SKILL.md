---
name: 04-pre-release-audit
description: Execute a strict, read-only readiness audit across code, specifications, user documentation, test suites, and CI/release pipelines (or scoped to a branch/PR diff) to identify P0 blockers and technical debt. Activate before tagging a release, reviewing a branch, or running /04-pre-release-audit.
metadata:
  lifecycle_stage: "04-pre-release"
  mode: "interactive | one-shot"
  recommended_flags: "--effort high"
---

# 04 — Pre-release & branch audit

## Constraints & role
1. **Strictly read-only**: Perform inspection, static analysis, and test execution only. Do not mutate git state, create tags, or edit files during this phase.
2. **Tone & signal**: Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md). **Do not summarize what is already working well**—report only concrete findings, drift, and actionable fixes.
3. **Stack verification**: Inspect `CWD` and consult [stack-routing.md](../../fragments/stack-routing.md) to execute the stack's automated test suite and static analysis commands.
4. **Audit mode selection**:
   - **Full release audit (default)**: When invoked with no scope arguments, audit the entire repository across all four sections below for release readiness.
   - **Branch / PR diff audit (when passed a ref, range, or issue `#id`)**: Scope inspection to the changed files (`git diff main...HEAD`), verifying Acceptance Criteria test coverage, `docs/spec/` synchronization, stack rule compliance, and full test/linter execution.

## Audit scope & evaluation criteria

### 1. Working tree, build & test verification
- Verify `git status` is clean (no uncommitted modifications or untracked build artifacts) and the active branch is the intended release target.
- Execute the full automated test suite (with race detection / memory checks enabled) and static analysis/linters (`go vet`, `shellcheck`, compiler warnings).

### 2. Cross-artifact consistency (Spec $\leftrightarrow$ Code $\leftrightarrow$ Docs $\leftrightarrow$ CI)
- Cross-reference CLI flags, environment variables, configuration schemas, exit codes, and public signatures in the source code against `docs/spec/`, `README.md`, and `docs/user-guide/`.
- Verify version strings, dependency matrices, and minimum runtime/compiler versions across build manifests (`go.mod`, `pom.xml`, `CMakeLists.txt`), `.github/workflows/`, and documentation.
- Flag deprecated features, dead references, or behavioral drift between documented examples and actual code paths.

### 3. Documentation depth & operational readiness
- Evaluate whether architectural invariants, edge cases, failure modes, and concurrency/performance constraints are documented with sufficient technical rigor.
- Identify **"happy-path bias"** where error handling, exit codes, recovery procedures, or platform-specific limitations (Linux/WSL vs. Windows) are omitted.
- Check operational onboarding: reproducible build instructions, local development setup, and dependency prerequisites.

### 4. Release governance, artifacts & CI/CD pipelines
- Verify the presence and completeness of standard repository and release files: `LICENSE`, `CHANGELOG.md` (with unreleased changes cataloged), `CONTRIBUTING.md` (when applicable), `.gitignore`, `.gitattributes`, and (if used by the repository) the `## 🤖 AI Disclosure` footer in root `README.md`.
- Audit CI/CD and release workflows (`.github/workflows/ci.yml`, `release.yml`, package manager publishers): automated test/lint gates, cross-platform artifact compilation, checksum generation, and badge/telemetry accuracy.
- Identify gaps in structured logging, diagnostic output (`stderr` prefixes/hints), or observability needed for production troubleshooting.

## Output contract
Produce a concise, actionable audit report containing:

1. **Verification checkpoint summary**:
   | Checkpoint | Status | Details |
   | :--- | :--- | :--- |
   | Working tree hygiene | Pass / Fail | ... |
   | Automated test suite & linter | Pass / Fail | ... |
   | Spec $\leftrightarrow$ Code $\leftrightarrow$ Docs alignment | Pass / Fail | ... |
   | Release & CI artifacts | Pass / Fail | ... |
   | **Release readiness verdict** | **GO** / **NO-GO** | **NO-GO** if any `P0` blocker exists |

2. **Prioritized findings** (omit empty tiers):
   - **Release blockers (`P0`):** Failing tests, critical spec/code/doc inconsistencies, broken build/release instructions, or missing legal/release artifacts that must be fixed before tagging.
   - **Technical & documentation debt (`P1`):** Undocumented edge cases/failure modes, happy-path bias, or fragile configurations.
   - **Polish & governance (`P2`):** Minor drift, community template gaps, or diagnostic/metric improvements.

3. **Remediation matrix**:
   | Priority | Finding | File / artifact | Concrete fix |
   | :--- | :--- | :--- | :--- |
   | `P0` / `P1` / `P2` | ... | `path/to/file` | Exact change required |
