# Git & branching conventions

## Branching model
- **Trunk-based workflow (`main`)**: `main` is the single integration branch and must always remain releasable. Never commit directly or force-push to `main`.
- **Branch prefixes & sync strategy**:
  - `issue/<key>` (e.g., `issue/42`, `issue/TASK-101`): Standard tasks and bug fixes (linear rebase sync onto `main`, squash-merge PR).
  - `feature/<key>`: Collaborative features (merge sync from `main`, squash-merge PR).
  - `epic/<key>`: Multi-commit initiatives (merge sync from `main`, non-squash true merge PR).
  - `<type>/<slug>`: Local untracked spikes when no issue key exists.

## Lifecycle commands (`git-brx` & standard `git` fallback)
Always use `git-brx` (`git brx`) when available on `PATH` (`which git-brx`). When `git-brx` is not installed, execute the equivalent guardrailed `git` fallback:

| Lifecycle stage | `git-brx` command (preferred) | Standard `git` fallback (when `git-brx` is absent) |
| :--- | :--- | :--- |
| **Create branch** | `git brx create <prefix>/<key> -y` *(add `-o` if offline)* | `git fetch origin main && git checkout -b <prefix>/<key> origin/main` |
| **Switch branch** | `git brx select [<branch>]` | `git fetch origin && git checkout <branch>` |
| **Sync with `main`** | `git brx sync` | `git fetch origin main` then `git rebase origin/main` (`issue/*`) or `git merge origin/main` (`feature/*`, `epic/*`) |
| **Pull branch updates** | `git brx update` | `git pull --rebase --autostash origin <branch>` |
| **Resolve conflicts** | `git brx resolve` | `git add <resolved-files>` *(never `git add .`)* && `git rebase --continue` *(or `git merge --continue`)* |
| **Abort / reset sync** | `git brx reset` | `git rebase --abort` *(or `git merge --abort`)* && `git reset --hard origin/<branch>` |
| **Publish branch** | `git brx publish` | `git push --force-with-lease -u origin HEAD` *(never raw `--force`)* |
| **Submit PR** | `git brx review` | `gh pr create` linking to `Closes #<key>` and `docs/spec/` |
| **Clean up branch** | `git brx delete <branch>` | `git checkout main && git pull --ff-only && git branch -d <branch>` *(verify merged first)* |

## Commit message conventions
- **Conventional commits**: Format all commit headers as `<type>(<scope>): <description>` (e.g., `feat(#42): ...` or `feat(cli): ...`) in lowercase imperative mood, under 72 characters, with no trailing period.
- **Allowed types**: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `ci`, `build`, `chore`.
- **Breaking changes**: Append `!` after the type/scope (`feat(cli)!: ...`) and include a `BREAKING CHANGE: <details>` footer when introducing backwards-incompatible changes.
- **Issue traceability**: Reference the source issue in the commit scope (`feat(#42): ...`) or footer (`Closes #42` / `Refs #42`).

## Pull requests, tags & submodules
- **Minimal PR descriptions**: Use `git brx review` (or link directly to the primary issue `Closes #<id>` and affected `docs/spec/` file(s) without duplicating the issue body).
- **Release tags**: Use annotated semantic version tags (`git tag -a vX.Y.Z -m "Release vX.Y.Z"`).
- **Submodules**: Commit submodule pointer updates in isolated, explicit commits (`chore(submodule): bump <name>`) only after the referenced commit has been pushed to the submodule remote.
