---
name: 01-spec-generation
description: Author or update authoritative technical specifications under docs/spec/ (global.md for system-wide architecture/invariants and <unit>.md for subcommands or modules) before writing implementation code. Activate when planning architecture, reverse-engineering legacy code, or running /01-spec-generation.
metadata:
  lifecycle_stage: "01-spec"
  mode: "interactive"
  recommended_flags: "--mode plan --effort high"
---

# 01 — Technical Specification Generation

## Constraints & Domain Rules
1. Read and enforce [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
2. Read and enforce [spec-driven-core.md](../../rules/spec-driven-core.md).
3. Inspect `CWD` and consult [stack-routing.md](../../fragments/stack-routing.md) to load the active language rule (`go-cli-standards.md`, `java-standards.md`, `embedded-standards.md`).

## Domain Template Routing
Select and read the specification template matching the target system's domain before drafting:

| Project Domain | Template to Load | Topology |
| :--- | :--- | :--- |
| **CLI Application** (Go, Rust, Python, C/C++) | [templates/cli.md](./templates/cli.md) | `docs/spec/global.md` + `docs/spec/<subcommand>.md` (or `global.md` only for single-command tools) |
| **Other Domains** (Library, Service, Firmware) | Fallback outline below (until a domain template is added under `templates/`) | `docs/spec/global.md` + optional `docs/spec/<module>.md` |

## Core Authoring Directives
1. **Strict Global Alignment (DRY)**:
   - `docs/spec/global.md` is the single source of truth for cross-cutting concerns, shared flags/options, configuration schemas, error codes, external execution boundaries, package layout, and shared domain models.
   - `docs/spec/<unit>.md` must reference `global.md` and never redefine global flags, shared structs, or global error sentinels.
   - Do not overengineer topology: split into `<unit>.md` files only when the project has multiple distinct subcommands or modules.
2. **Decoupled Testability Boundary**:
   - Specify narrow execution/runner interfaces (`Runner`, `Inspector`, `Manager`, `HAL`) in `global.md` so domain logic in `<unit>.md` can be unit-tested in isolation from CLI/transport/hardware layers.
3. **Legacy Reverse-Engineering Mode (When `/legacy` or Reference Code Exists)**:
   - Abstract away source-language mechanics (e.g., Bash subshells, `awk`/`sed` pipelines, unquoted globals) into idiomatic target-stack contracts and stdlib equivalents.
   - Clean-break modernization: fix fragile legacy behaviors (race conditions, non-atomic writes, localized porcelain parsing) rather than preserving bugs, and include the conditional **Legacy Discrepancies & Modernization Decisions** section in `global.md`.
4. **Pre-Flight Ambiguity Check**:
   - Inspect `README.md`, build markers, existing `docs/spec/` files, and any `/legacy` sources first. If critical architectural decisions remain ambiguous, ask concise clarifying questions before generating the spec.

## Fallback Outline for Non-CLI Domains
When authoring specifications for non-CLI domains without a dedicated file in `templates/`, structure `docs/spec/global.md` (and optional `docs/spec/<module>.md`) covering:
1. **System Overview & Public Interface / Protocol Conventions**
2. **Runtime Environment, Dependencies & Configuration Schema**
3. **Error Taxonomy & Fault / Status Code Matrix**
4. **Execution Boundaries, Concurrency & Resource/ISR Safety**
5. **Package / Module Architecture & Shared Domain Models**
6. **Module Registry & Verification Plan**
