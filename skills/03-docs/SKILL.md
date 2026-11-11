---
name: 03-docs
description: Audit and refine user guides, READMEs, and reference documentation for pragmatic developer-to-developer tone, plain active English, sentence-case headings, factual spec/codebase accuracy, and link integrity. Activate when reviewing documentation or running /03-docs.
metadata:
  lifecycle_stage: "03-docs"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 03 — Documentation review

## Constraints & voice separation
- **Agent chat response:** Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md) for your audit commentary (no chat pleasantries or filler).
- **Documentation prose voice:** Optimize the documentation itself for a **pragmatic, peer-to-peer developer voice**—preserve natural explanatory flow, architectural context ("why" before "how"), and human readability rather than flattening user guides into dry specification telegraphese.

## Scope & ground truth separation
1. **Target files (to audit & refine)**:
   - If specific file paths are passed as arguments, review only those files.
   - Otherwise, inspect `README.md`, `CONTRIBUTING.md`, and user/reference documentation under `docs/` (such as `docs/user-guide/**/*.md`), **excluding** `docs/spec/`.
2. **Ground truth (read-only reference)**:
   - Use `docs/spec/` (`global.md` and `<unit>.md`) and the codebase implementation strictly as read-only ground truth to verify technical accuracy. Never rewrite `docs/spec/` during a documentation tone review.

## Style, tone & accuracy checklist

### 1. Peer-to-peer developer voice
- Write for experienced engineers. Keep the tone direct, natural, and conversational without being sloppy.
- Favor active voice, strong verbs, concise sentences, tables, and concrete examples over dense blocks of abstract prose.

### 2. Cut marketing & AI fluff
- Eliminate brochure-ware, hype, and AI-generated buzzwords: *"seamless," "cutting-edge," "paradigm shift," "empower," "next-generation," "out-of-the-box," "robust," "delve," "leverage," "streamline," "effortlessly," "comprehensive."*
- State directly what the tool actually does, how it works, and what constraints apply.

### 3. Plain, active English (avoid academic & stiff phrasing)
- Replace overly formal, passive, or robotic transitions with plain, active English:
  - *"utilize"* $\rightarrow$ *"use"*
  - *"facilitate"* $\rightarrow$ *"help"*
  - *"in order to"* $\rightarrow$ *"to"*
  - *"prior to"* / *"subsequent to"* $\rightarrow$ *"before"* / *"after"*
  - *"furthermore"* / *"moreover"* $\rightarrow$ *"also"*
  - *"it should be noted that"* / *"herein"* $\rightarrow$ *"note that"* or state the fact directly.

### 4. Technical precision, spec alignment & link integrity
- **Sentence-case headings, tables & labels:** Ensure all Markdown headings, table column headers, and bold row/list labels use sentence case (e.g., `## Multi-stack domain rule routing`, capitalizing only the first word and proper nouns/acronyms like `Go`, `Git`, `CLI`, `CI`, `TDD`, `SemVer`) rather than Title Case.
- **Preserve technical precision:** Do not alter code blocks, CLI flags, configuration keys, exit codes, or exact technical meanings while simplifying surrounding prose.
- **Spec & codebase cross-check:** Flag any documented command syntax, flag default, config key, or example output that contradicts `docs/spec/` or the implementation.
- **Link & formatting hygiene:** Verify internal Markdown links resolve on disk, heading hierarchy is consistent, and code blocks carry valid language tags (`bash`, `yaml`, `go`, `text`).
- **Root `README.md` AI disclosure footer (conditional):** If the repository uses an `## 🤖 AI Disclosure` footer (or if requested by the user), verify that root `README.md` ends with the standard section:
  ```markdown
  ---

  ## 🤖 AI Disclosure

  ![AI Assisted](https://img.shields.io/badge/AI-Assisted-blue?style=flat-square)

  This project was developed with the assistance of AI tools. All AI-generated code has been reviewed, tested, and manually refined.
  ```

## Output contract
For each reviewed file:
1. **Key edits & findings:** Bullet the most significant phrasing, tone, or structural improvements made (plus any spec/code/link discrepancies found) and why.
2. **Revised documentation:**
   - In interactive mode (`agy -i`): Propose and apply the cleaned-up Markdown edits directly to the target file(s) upon user confirmation (or provide the ready-to-copy revised Markdown when reviewing a single snippet/file).
   - In headless mode (`agy -p`): Output the **Key edits & findings** summary followed by the cleaned-up **Revised text** (or unified diffs for multi-file audits).
