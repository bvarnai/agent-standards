# Commit conventions

## Commit messages
- **Format:** `<type>(<component>): <description>` in lowercase imperative mood, at most 72 characters, no trailing period (e.g., `feat(cli): add --dry-run flag`). The scope names the component that changed, never an issue number.
- **Allowed types:** `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `ci`, `build`, `chore`.
- **Breaking changes:** append `!` after the type or scope (`feat(cli)!: ...`) and add a `BREAKING CHANGE: <details>` footer.
- **Submodules:** commit submodule pointer updates in their own commit (`chore(submodule): bump <name>`), only after the referenced commit is pushed to the submodule remote.

## Branches, syncing, PRs, and merging
Out of scope for these rules. Use `git brx` (and its skill) when `git-brx` is on `PATH`; otherwise follow the project's own conventions.
