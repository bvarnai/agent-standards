---
name: 03-docs-tone-review
description: Audit and refine user guides, READMEs, and reference documentation for pragmatic developer-to-developer tone, plain active English, factual spec/codebase accuracy, and link integrity. Activate when reviewing documentation or running /03-docs-tone-review.
metadata:
  lifecycle_stage: "03-docs-review"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 03 — Documentation & Technical Tone Review

## Constraints & Voice Separation
- **Agent Chat Response:** Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md) for your audit commentary (no chat pleasantries or filler).
- **Documentation Prose Voice:** Optimize the documentation itself for a **pragmatic, peer-to-peer developer voice**—preserve natural explanatory flow, architectural context ("why" before "how"), and human readability rather than flattening user guides into dry specification telegraphese.

## Scope & Ground Truth Separation
1. **Target Files (To Audit & Refine)**:
   - If specific file paths are passed as arguments, review only those files.
   - Otherwise, inspect `README.md`, `CONTRIBUTING.md`, and user/reference documentation under `docs/` (such as `docs/user-guide/**/*.md`), **excluding** `docs/spec/`.
2. **Ground Truth (Read-Only Reference)**:
   - Use `docs/spec/` (`global.md` and `<unit>.md`) and the codebase implementation strictly as read-only ground truth to verify technical accuracy. Never rewrite `docs/spec/` during a documentation tone review.

## Style, Tone & Accuracy Checklist

### 1. Peer-to-Peer Developer Voice
- Write for experienced engineers. Keep the tone direct, natural, and conversational without being sloppy.
- Favor active voice, strong verbs, concise sentences, tables, and concrete examples over dense blocks of abstract prose.

### 2. Cut Marketing & AI Fluff
- Eliminate brochure-ware, hype, and AI-generated buzzwords: *"seamless," "cutting-edge," "paradigm shift," "empower," "next-generation," "out-of-the-box," "robust," "delve," "leverage," "streamline," "effortlessly," "comprehensive."*
- State directly what the tool actually does, how it works, and what constraints apply.

### 3. Plain, Active English (Avoid Academic & Stiff Phrasing)
- Replace overly formal, passive, or robotic transitions with plain, active English:
  - *"utilize"* $\rightarrow$ *"use"*
  - *"facilitate"* $\rightarrow$ *"help"*
  - *"in order to"* $\rightarrow$ *"to"*
  - *"prior to"* / *"subsequent to"* $\rightarrow$ *"before"* / *"after"*
  - *"furthermore"* / *"moreover"* $\rightarrow$ *"also"*
  - *"it should be noted that"* / *"herein"* $\rightarrow$ *"note that"* or state the fact directly.

### 4. Technical Precision, Spec Alignment & Link Integrity
- **Preserve Technical Precision:** Do not alter code blocks, CLI flags, configuration keys, exit codes, or exact technical meanings while simplifying surrounding prose.
- **Spec & Codebase Cross-Check:** Flag any documented command syntax, flag default, config key, or example output that contradicts `docs/spec/` or the implementation.
- **Link & Formatting Hygiene:** Verify internal Markdown links resolve on disk, heading hierarchy is consistent, and code blocks carry valid language tags (`bash`, `yaml`, `go`, `text`).

## Output Contract
For each reviewed file:
1. **Key Edits & Findings:** Bullet the most significant phrasing, tone, or structural improvements made (plus any spec/code/link discrepancies found) and why.
2. **Revised Documentation:**
   - In interactive mode (`agy -i`): Propose and apply the cleaned-up Markdown edits directly to the target file(s) upon user confirmation (or provide the ready-to-copy revised Markdown when reviewing a single snippet/file).
   - In headless mode (`agy -p`): Output the **Key Edits & Findings** summary followed by the cleaned-up **Revised Text** (or unified diffs for multi-file audits).
