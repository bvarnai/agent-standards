---
name: 00-issue-generation
description: Strictly draft Git issues using the mandatory issue template with clear problem context, acceptance criteria, edge cases, and verification plans, saving the raw Markdown to .issue-draft.md. Activate whenever asked to write, draft, or generate an issue (feat:, fix:, refactor:, perf:, docs:, test:, ci:, build:, chore:) or running /00-issue-generation.
metadata:
  lifecycle_stage: "00-issue"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 00 — Git issue generation

## Constraints
- Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
- Inspect the current working directory (`CWD`) and consult [stack-routing.md](../../fragments/stack-routing.md) to populate concrete file paths and stack-specific verification commands.
- **Root-cause triage for `fix:` issues**: When drafting a bug/regression issue (`fix:`), inspect the relevant source files first to identify the concrete root cause, reproduction conditions, and whether `docs/spec/` requires an edge-case or error-matrix update.
- **Proportionality**: Scale depth to complexity. For trivial `chore:` or `docs:` issues, keep design bullets minimal and explicitly mark `Edge cases & failure modes` as `None (trivial change)` rather than inventing filler.
- **Pre-flight ambiguity check**: If the request lacks critical architectural context, ask at most 1–3 concise clarifying questions before generating the issue.

## Output contract (raw Markdown file)
1. Write the generated issue in raw GitHub Flavored Markdown (no outer ` ```markdown ` wrapper, and with HTML guidance comments stripped) directly to `.issue-draft.md` in `CWD` (`Overwrite: true`). Invoking this skill grants explicit permission to create or overwrite `.issue-draft.md` without an additional confirmation prompt.
2. Output the rendered issue in chat and provide:
   - A clickable link to `.issue-draft.md`.
   - A ready-to-run GitHub CLI command: `gh issue create --title "<type>(<scope>): <title>" --body-file .issue-draft.md`.

## Mandatory issue layout template

Format the issue strictly using the template below in GitHub Flavored Markdown:

```markdown
### [Type]: Short title (matching Git conventions)

**Problem / context**
<!-- Current state, root cause or motivation, and why this change is needed now. -->

**Proposed changes & technical design**
<!-- Concrete architectural approach, file/API/schema impacts, and explicit non-goals if applicable. -->
- **Affected files / components:** `path/to/file`
- **Design:** ...
- **Out of scope:** (Optional — omit if trivial)

**Acceptance criteria**
- [ ] Criterion 1 (Functional, testable requirement)
- [ ] Criterion 2 (Functional, testable requirement)

**Edge cases & failure modes**
<!-- Boundary conditions, race conditions, error propagation, or null-handling rules. Write "None (trivial change)" if N/A. -->

**Verification & testing plan**
- [ ] **Unit tests:** [Target coverage, specific test conditions, and exact stack runner command]
- [ ] **Manual / integration verification:** [Steps to verify the change works end-to-end]
```
