# Tests

Static checks for the plugin's prompt files. They read files only: no agent runs, no model calls, no network. That makes them deterministic and safe to run on every change, or in CI.

| File | What it checks |
| :--- | :--- |
| `lint/frontmatter.bats` | Every `skills/*/SKILL.md` has YAML frontmatter with a non-empty `description` and a `name` that matches its directory. |
| `lint/links.bats` | Every relative Markdown link and `@[…](…)` import in `rules/`, `skills/`, `standards/`, `fragments/`, `docs/`, and `README.md` resolves. Links inside code blocks and inline code are ignored. |
| `lint/budget.bats` | `rules/GEMINI.md` plus its `@` imports stays within Antigravity's [24,000-byte rule cap](https://antigravity.google/docs/rules-workflows). Over the cap, Antigravity truncates the file. |

## Requirements

- [`bats-core`](https://github.com/bats-core/bats-core) and [`shellcheck`](https://www.shellcheck.net/) on `PATH`
- The [`bats-support`](https://github.com/bats-core/bats-support) and [`bats-assert`](https://github.com/bats-core/bats-assert) libraries in a directory listed in `BATS_LIB_PATH` (loaded with `bats_load_library`)

## Running

```bash
bats tests/lint
shellcheck tests/lint/helpers.bash
```

These checks catch structural problems. They don't check whether the agent behaves as intended. For that, reread the rules and skills as a whole, for example by running `/04-audit` against this repo before tagging a release.
