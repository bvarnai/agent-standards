---
name: 06-project-harmonization
description: Compare two projects (a Reference repository and a Target repository) to perform a structural gap analysis and produce a deterministic uplift plan across specifications, package/build architecture, CI/release pipelines, and documentation. Activate when comparing, aligning, or harmonizing two repositories or running /06-project-harmonization.
metadata:
  lifecycle_stage: "06-harmonization"
  mode: "interactive"
  recommended_flags: "--mode plan --effort high"
---

# 06 — Cross-Project Comparison & Harmonization

## Constraints & Workspace Boundaries
1. **Tone & Precision**: Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md). Do not emit generic boilerplate; base every finding and action strictly on the concrete delta between the two inspected repositories.
2. **Input Resolution**:
   - Identify the **Reference Repository (`<reference-repo>`)** (the target standard) and the **Target Repository (`<target-repo>`)** (the project to be uplifted). If ambiguous, ask the user to confirm which repository is the reference before proceeding.
3. **Read-Only Reference Boundary**:
   - Treat `<reference-repo>` as strictly read-only unless the user explicitly approves backporting an improvement discovered in `<target-repo>`.
   - Scope all build, test, and linter verification commands (via [stack-routing.md](../../fragments/stack-routing.md)) to `<target-repo>`.

## Harmonization Scope

### 1. Specification Format & Layout (`docs/spec/` or Equivalent)
- Align directory structure (`global.md` + `<unit>.md`), file naming conventions, and section headers.
- Standardize technical rigor, state machine/execution flow definitions, flag/interface tables, exit/error code matrices, and edge-case coverage.

### 2. Project Scaffolding, Package Architecture & Release Methodology
- Unify directory and package layout (e.g., `cmd/`, `internal/` shared packages like `term`, `errcode`, `checks`, `config`, `version`, `scripts/`, `test/`).
- Standardize build orchestration, linter configurations, and dependency hygiene.
- Align CI/CD and release pipelines (`.github/workflows/ci.yml`, `release.yml`, package manager publishers), version metadata resolution, checksums, and release artifact naming.

### 3. Documentation Artifacts, Tone & Governance
- Standardize root-level and governance files (`README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `LICENSE`, `.gitignore`, `.gitattributes`, `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/`, and agent rule/skill files).
- Harmonize user guide structure (`docs/user-guide/`), technical tone, installation instructions, usage examples, and architectural overview sections.

## Output Contract
Produce a deterministic 3-part harmonization report and plan:

### 1. Structural Diff & Gap Analysis
Compare the two repositories across all three scope areas:

| Component / Area | `<reference-repo>` (Reference) | `<target-repo>` (Current) | Required Action (Uplift / Backport) |
| :--- | :--- | :--- | :--- |
| `docs/spec/` | ... | ... | ... |
| Package Layout (`internal/...`) | ... | ... | ... |
| CI / Release Workflows | ... | ... | ... |
| Docs & Governance | ... | ... | ... |

### 2. Canonical Template Definition
Define the unified directory tree and shared file/package manifest that both repositories will share once harmonized.

### 3. Step-by-Step Uplift Plan
Provide an ordered, file-by-file implementation checklist to bring `<target-repo>` up to the `<reference-repo>` standard (and highlight any superior patterns in `<target-repo>` worth backporting to `<reference-repo>`):
- Specify exact file paths, required renames, package migrations, workflow updates, and documentation rewrites.
- Wait for explicit user approval before executing the uplift steps.
