---
name: 02-implementation
description: Implement features, refactors, or bug fixes strictly traceable to an approved specification or issue, enforcing stack-specific engineering standards, living spec synchronization, and automated test verification. Activate when implementing code, fixing bugs, or running /02-implementation.
metadata:
  lifecycle_stage: "02-implementation"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 02 — Spec-driven implementation

## Constraints
- Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).

## Input contract
1. **Source of truth**:
   - Require an explicit issue (or `.issue-draft.md` in `CWD`) and/or approved specification in `docs/spec/`. If neither exists, halt and invoke `/00-issue-generation` or `/01-spec-generation` first.
   - When `docs/spec/global.md` exists alongside `docs/spec/<unit>.md`, read both `global.md` (for shared architecture, error codes, execution boundaries, and package dependency rules) and the target `<unit>.md` before writing code.
2. **Topic branch check**:
   - Inspect `git branch --show-current`. If working on a tracked issue while still on `main`, propose creating the topic branch first via `git brx create issue/<id> -y` (or the standard `git` fallback in [`rules/git.md`](../../rules/git.md) if `git-brx` is not installed).

## Implementation workflows

### 1. Feature / refactor workflow
1. **Day-0 scaffolding (new repositories only)**: When bootstrapping a brand-new project from `docs/spec/`, initialize standard governance and build files (`LICENSE`, `README.md`, `CHANGELOG.md`, `.gitignore`, `.gitattributes` with `* text=auto eol=lf`, and `.github/workflows/ci.yml`).
2. **Boundary & domain implementation**: Implement narrow execution/runner interfaces (`Runner`, `Inspector`, `HAL`) and core domain logic in small, bisectable units matching the package dependency direction in `global.md`.
3. **Automated tests**: Write unit and black-box verification tests covering every Acceptance Criterion, Edge Case, and Error Matrix row in the spec/issue.

### 2. Bug fix / regression workflow (`fix:`)
1. **Reproduce first (TDD)**: Write a deterministic failing unit or integration test that reproduces the reported bug or edge case before modifying production logic.
2. **Root-cause fix**: Apply the minimal, idiomatic fix at the root cause (avoiding symptom-level workarounds).
3. **Spec check**: If the bug exposed an undocumented invariant or exit code trigger, update `docs/spec/` to lock in the expected behavior.

### 3. Verification gate
- Run the stack's automated test suite and static analysis commands from [`rules/stack-routing.md`](../../rules/stack-routing.md) (`go test -race ./...`, `go vet ./...`, `./mvnw test`, `shellcheck`, `bats`, `ctest`).
- Do not claim completion until all automated tests and linters pass with zero warnings or errors.

## Output contract & commit / PR handoff
Upon passing verification, output:
1. **Acceptance criteria verification matrix**:
   | Acceptance criterion / edge case | Status | Verifying test / file |
   | :--- | :--- | :--- |
   | ... | Pass | `path/to/test_file:TestName` |
2. **Proposed Git & `git-brx` commands** (use the standard `git` fallbacks in [`rules/git.md`](../../rules/git.md) if `git-brx` is not installed; never stage `.issue-draft.md`; wait for user confirmation before executing mutating Git commands):
   ```bash
   git add <modified-files>
   git commit -m "<type>(#<issue-id>): <concise summary>" -m "Closes #<issue-id>"
   git brx sync
   git brx publish
   git brx review
   ```
