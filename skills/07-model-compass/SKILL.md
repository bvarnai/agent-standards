---
name: 07-model-compass
description: Review currently available AI models in Antigravity (agy), evaluate their coding precision vs. deep reasoning/synthesis strengths, and update the Model & Effort Mental Compass table in README.md. Activate when asked to review models, refresh model recommendations, or running /07-model-compass.
metadata:
  lifecycle_stage: "07-maintenance"
  mode: "interactive"
  recommended_flags: "--effort medium"
---

# 07 — Model & effort compass review

## Constraints & role
1. **Tone**: Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).
2. **Evidence-based evaluation**: Evaluate models strictly on practical engineering execution—surgical code-edit precision, multi-step tool-loop speed, instruction adherence, and multi-file architectural synthesis—rather than marketing claims.
3. **Scope**: Keep `skills/*/SKILL.md` frontmatter model-agnostic (`--effort` and `--mode` only); record concrete model name recommendations exclusively in the **Model & effort mental compass** table in [README.md](../../README.md).

## Discovery & evaluation procedure

### 1. Discover available models
Gather the active candidate models from:
1. **User arguments / active selector**: Any model names or observations passed by the user (e.g., models visible in the `agy` `/model` selector across `personal` and `work` profiles).
2. **Current baseline**: Read the existing **Model & effort mental compass** table in [README.md](../../README.md).
3. **Live documentation & release notes**: Use `search_web` to check the latest Antigravity changelog (`https://antigravity.google/changelog`), CLI reference (`https://antigravity.google/docs/cli/reference`), and current frontier model releases/benchmarks for agentic coding and reasoning.
4. **Pre-flight check**: If internal or preview model names exist in the user's `/model` menu that are not publicly documented, ask the user to list the models currently shown in their `/model` selector before finalizing.

### 2. Evaluate against lifecycle task profiles
Classify the available models across the five `agent-standards` execution profiles:

| Task profile | Lifecycle stages | Primary bottleneck | Key selection criteria | Default effort |
| :--- | :--- | :--- | :--- | :--- |
| **1. Architecture, specs & cross-repo uplift** | `01-spec-generation`<br>`06-project-harmonization` | Multi-file synthesis & invariant design | Deepest reasoning, legacy reverse-engineering accuracy, long-context coherence. | `--mode plan --effort high` |
| **2. Pre-release & cross-artifact audit** | `04-pre-release-audit` | High-recall cross-checking (Spec $\leftrightarrow$ Code $\leftrightarrow$ Docs $\leftrightarrow$ CI) | Low false-positive rate, high attention across many files in a single read-only pass. | `--effort high`<br>*(or `medium` for branch diffs)* |
| **3. Hands-on coding, TDD & tool loops** | `02-implementation`<br>`00-issue-generation` | 10–20 step tool-loop latency & surgical diff quality | Strict adherence to existing code style, minimal over-abstraction, fast `edit_file` $\rightarrow$ test cycles. | `--effort medium`<br>*(or `high` for race/concurrency bugs)* |
| **4. Documentation tone & accuracy review** | `03-docs-review` | Natural developer prose + technical verification | Avoids stiff AI phrasing while accurately cross-checking flags and examples against code. | `--effort medium` |
| **5. Mechanical release cut** | `05-release` | Turnaround speed & strict procedure compliance | Fast, deterministic execution (SemVer bump, `CHANGELOG.md` update, Git tag staging) without re-auditing. | `--effort low` |

## Output contract
1. **Model evaluation summary**:
   - List the evaluated models and any changes compared to the previous [README.md](../../README.md) table (which model leads for **Deep reasoning / architecture** vs. **Hands-on coding / tool loops** vs. **Fast mechanical tasks**, and why).
2. **Update [README.md](../../README.md)**:
   - Propose and apply the updated **Model & effort mental compass** table in [README.md](../../README.md) upon user confirmation.
