---
name: 01-spec-generation
description: Author or update a comprehensive technical specification under docs/spec/ from requirements, user stories, or a Git issue before writing implementation code. Activate when planning architecture, starting a feature, or running /01-spec-generation.
metadata:
  lifecycle_stage: "01-spec"
  mode: "interactive"
  recommended_flags: "--mode plan --effort high"
---

# 01 — Technical Specification Generation

## Constraints & Domain Rules
1. Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
2. Read and enforce [spec-driven-core.md](../../rules/spec-driven-core.md).
3. Inspect the current working directory (`CWD`) and consult [stack-routing.md](../../fragments/stack-routing.md) to load the active domain rule (e.g. Go, Java, Embedded).

## Input Contract (Target Workspace CWD)
1. **Required Context**:
   - Inspect `README.md` and any existing architecture docs under `docs/` or `docs/spec/`.
   - Read the reference issue or requirement provided in the prompt.
2. **Missing Context Handling**:
   - If requirements are ambiguous, ask clarifying questions before committing to an architecture.
   - If `docs/spec/` does not exist, propose creating it.
3. **Output Contract**:
   - Generate or update `docs/spec/<feature-name>.md` using Unix (`LF`) line endings.
   - The specification must include:
     - **Context & Objectives**: Problem definition and business/technical motivation.
     - **Architecture & Technical Design**: Data flows, schema changes, API contracts, sequence diagrams (`mermaid`).
     - **Traceability to Acceptance Criteria**: Concrete, testable checklist items.
     - **Edge Cases & Failure Modes**: Error handling, timeouts, resource limits, and race conditions.
     - **Verification Plan**: Exact commands for unit, integration, and end-to-end tests.
