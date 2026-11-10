# agent-standards

Single source of truth for AI developer agent standards, universal lifecycle skills, and stack-specific engineering rules.

Designed for native integration with `antigravity-cli` (`agy`) and compatible with modern AI agent workflows.

---

## Repository Architecture

The repository separates **universal developer workflows** from **stack-specific engineering standards**, allowing you to use identical commands across any programming language or project:

```text
agent-standards/
├── README.md                           # Architecture and usage guide
├── skills.json                         # Native agy customization manifest
├── rules/                              # Persistent & domain-specific rules
│   ├── GEMINI.md                       # Baseline rules (Platform assumptions, LF, Tool Policy)
│   ├── spec-driven-core.md             # Spec-first & Issue-as-Source-of-Truth core rules
│   ├── go-cli-standards.md             # Go CLI architecture, error wrapping & testing
│   ├── java-standards.md               # Modern Java idioms, null-safety, Maven/Gradle verification
│   ├── embedded-standards.md           # Embedded C/C++ deterministic memory, ISR safety, HAL
│   └── shell-standards.md              # Bash/Shell naming (kebab-case CLI), safety, shellcheck & Bats
├── skills/                             # Universal lifecycle skills (agy slash commands)
│   ├── 00-issue-generation/SKILL.md    # Mandatory Git issue drafting template (.issue-draft.md)
│   ├── 01-spec-generation/
│   │   ├── SKILL.md                    # Interactive spec authoring & domain template router
│   │   └── templates/
│   │       └── cli.md                  # Field-proven CLI spec templates (global.md + <subcommand>.md)
│   ├── 02-implementation/SKILL.md      # Spec-driven implementation + test verification
│   ├── 03-docs-tone-review/SKILL.md    # Documentation & tone audit
│   ├── 04-pre-release-audit/SKILL.md   # One-shot pre-release readiness audit
│   ├── 05-release/SKILL.md             # Version bump, changelog & release tag
│   └── 06-project-harmonization/SKILL.md # Cross-repo gap analysis & uplift plan
└── fragments/                          # Reusable blocks & contracts
    ├── strict-technical-tone.md        # Concise developer-to-developer output constraint
    └── stack-routing.md                # CWD marker -> domain rule routing table
```

---

## Universal Lifecycle Skills

Run these skills from inside the `agy` TUI or directly from your terminal:

| Stage | Slash Command | CLI Interactive (`agy -i`) | CLI Headless / Audit (`agy -p`) | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **0. Issue** | `/00-issue-generation` | `agy -i "/00-issue-generation feat: add foo"` | `agy -p "/00-issue-generation feat: add foo"` | Draft strict, spec-driven Git issues. |
| **1. Spec** | `/01-spec-generation` | `agy --mode plan --effort high -i "/01-spec-generation"` | — | Author technical specs in `docs/spec/`. |
| **2. Code** | `/02-implementation` | `agy --effort high -i "/02-implementation #42"` | — | Implement changes traceable to an issue/spec. |
| **3. Docs** | `/03-docs-tone-review` | `agy -i "/03-docs-tone-review"` | `agy -p "/03-docs-tone-review"` | Audit docs for tone and factual accuracy. |
| **4. Audit** | `/04-pre-release-audit` | — | `agy --effort high -p "/04-pre-release-audit"` | Read-only release readiness checklist. |
| **5. Release** | `/05-release` | `agy -i "/05-release v1.2.0"` | — | Finalize changelog, bump version, stage tags. |
| **6. Harmonize** | `/06-project-harmonization` | `agy --mode plan --effort high -i "/06-project-harmonization"` | — | Compare two repos & plan structural uplift. |

---

## Multi-Stack Domain Rule Routing

Lifecycle skills automatically inspect the current working directory (`CWD`) and load the matching rule file via `fragments/stack-routing.md`:

- **Go**: Triggered by `go.mod` $\rightarrow$ enforces [rules/go-cli-standards.md](rules/go-cli-standards.md) (`go test -race ./...`).
- **Java**: Triggered by `pom.xml` / `build.gradle` $\rightarrow$ enforces [rules/java-standards.md](rules/java-standards.md) (`./mvnw test` / `./gradlew check`).
- **Embedded C/C++**: Triggered by `CMakeLists.txt` / `platformio.ini` / `Kconfig` / `*.ld` $\rightarrow$ enforces [rules/embedded-standards.md](rules/embedded-standards.md) (deterministic memory, ISR safety).
- **Shell / Bash**: Triggered by `*.sh` / `*.bats` / `.bashrc.d/` $\rightarrow$ enforces [rules/shell-standards.md](rules/shell-standards.md) (`kebab-case` public interfaces, `shellcheck`, `bats`).

To add a new stack (e.g. Rust, Python), create `rules/<stack>-standards.md` and add one row to `fragments/stack-routing.md`.

---

## Machine Setup for `antigravity-cli` (`agy`)

To make these skills and rules globally available across all your repositories with zero project-level configuration:

### 1. Register Skills Globally
Add this repository to your global `~/.gemini/config/skills.json`:

```json
{
  "inherits": [
    {
      "path": "~/workspace/agent-standards/skills.json"
    }
  ]
}
```

### 2. Point Global Rules to `rules/GEMINI.md`
Ensure your `~/.gemini/GEMINI.md` inherits or symlinks to `rules/GEMINI.md`:
```bash
ln -sf ~/workspace/agent-standards/rules/GEMINI.md ~/.gemini/GEMINI.md
```
Or include it inside your existing `GEMINI.md`:
```markdown
@[Baseline Rules](~/workspace/agent-standards/rules/GEMINI.md)
```
