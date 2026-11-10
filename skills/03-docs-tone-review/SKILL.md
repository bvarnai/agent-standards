---
name: 03-docs-tone-review
description: Audit documentation, comments, and README files against technical tone standards, factual codebase accuracy, and link integrity. Activate when auditing documentation or running /03-docs-tone-review.
metadata:
  lifecycle_stage: "03-docs-review"
  mode: "one-shot"
  recommended_flags: "--effort medium"
---

# 03 — Documentation & Technical Tone Review

## Constraints
- Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).

## Input Contract (Target Workspace CWD)
1. **Target Files**:
   - Inspect `README.md`, `CONTRIBUTING.md`, and Markdown files under `docs/`.
   - Inspect API docstrings or package documentation if requested.
2. **Review Checklist**:
   - [ ] **Tone & Brevity**: Remove conversational filler, marketing fluff, passive voice, and redundant introductory text.
   - [ ] **Factual & Spec Accuracy**: Verify that code snippets, command line flags, exit codes, configuration keys, and path references match both `docs/spec/` (`global.md` and `<unit>.md` if present) and the actual codebase implementation.
   - [ ] **Link Integrity**: Verify that internal file links and external URLs resolve properly.
   - [ ] **Formatting**: Ensure consistent heading hierarchy, valid code fences with language tags, and well-formed tables.

## Output Contract
Provide a structured Markdown audit report:
- **Summary**: High-level verdict (Pass / Revisions Recommended).
- **Flagged Issues**: File path, line number, issue category, current text, and proposed replacement.
- **Suggested Diffs**: Ready-to-apply diff blocks for direct review.
