# shellcheck shell=bash
# Shared helpers for the static prompt checks in tests/lint.
# These checks read files only: no agy, no model calls, no network.

bats_load_library bats-support
bats_load_library bats-assert

REPO_ROOT="$(cd -- "${BATS_TEST_DIRNAME}/../.." && pwd)"
export REPO_ROOT

# check_frontmatter <skill-file> <expected-name>
# Fails unless the file starts with closed YAML frontmatter containing a
# non-empty description and a name equal to <expected-name>.
check_frontmatter() {
  local file="$1"
  local expected_name="$2"
  local frontmatter
  local name

  if [[ "$(head -n 1 -- "${file}")" != "---" ]]; then
    echo "${file}: missing opening '---' frontmatter line" >&2
    return 1
  fi

  if ! frontmatter="$(awk '
    NR == 1 { next }
    /^---[[:space:]]*$/ { closed = 1; exit }
    { print }
    END { exit closed ? 0 : 1 }
  ' "${file}")"; then
    echo "${file}: frontmatter is not closed with '---'" >&2
    return 1
  fi

  name="$(sed -n 's/^name:[[:space:]]*//p' <<<"${frontmatter}" \
    | head -n 1 \
    | sed -e 's/[[:space:]]*$//' -e "s/^[\"']\\(.*\\)[\"']\$/\\1/")"
  if [[ -z "${name}" ]]; then
    echo "${file}: frontmatter has no name" >&2
    return 1
  fi
  if [[ "${name}" != "${expected_name}" ]]; then
    echo "${file}: name '${name}' does not match directory '${expected_name}'" >&2
    return 1
  fi

  if ! grep -q '^description:[[:space:]]*[^[:space:]]' <<<"${frontmatter}"; then
    echo "${file}: frontmatter has no description" >&2
    return 1
  fi
}

# extract_links <markdown-file>
# Prints every Markdown link target, ignoring fenced code blocks and inline
# code spans. Covers [text](target), ![alt](target), and @[label](target).
extract_links() {
  awk '
    /^[[:space:]]*(```|~~~)/ { in_fence = !in_fence; next }
    in_fence { next }
    {
      line = $0
      gsub(/`[^`]*`/, "", line)
      while (match(line, /\]\([^) ]+/)) {
        print substr(line, RSTART + 2, RLENGTH - 2)
        line = substr(line, RSTART + RLENGTH)
      }
    }
  ' "$1"
}

# check_links <markdown-file>
# Fails if any relative link target does not exist. External links and
# pure anchors are ignored; #anchor suffixes are stripped before checking.
check_links() {
  local file="$1"
  local base_dir
  local target
  local path
  local failures=0

  base_dir="$(dirname -- "${file}")"
  while IFS= read -r target; do
    case "${target}" in
      http://* | https://* | mailto:* | file://* | '#'*) continue ;;
    esac
    path="${target%%#*}"
    if [[ -z "${path}" ]]; then
      continue
    fi
    if [[ ! -e "${base_dir}/${path}" ]]; then
      echo "${file}: broken link -> ${target}" >&2
      failures=$((failures + 1))
    fi
  done < <(extract_links "${file}")

  [[ "${failures}" -eq 0 ]]
}

# markdown_files
# Prints every Markdown file that ships with the plugin.
markdown_files() {
  find "${REPO_ROOT}/rules" "${REPO_ROOT}/skills" "${REPO_ROOT}/standards" \
    "${REPO_ROOT}/fragments" "${REPO_ROOT}/docs" -type f -name '*.md' -print
  printf '%s\n' "${REPO_ROOT}/README.md"
}

# rule_imports <rule-file>
# Prints the target path of every @[label](path) import.
rule_imports() {
  grep -oE '@\[[^]]*\]\([^)]*\)' "$1" | sed -E 's/^@\[[^]]*\]\((.*)\)$/\1/' || true
}

# expanded_rule_size <rule-file>
# Prints the byte size of a rule file plus all files it @-imports.
expanded_rule_size() {
  local file="$1"
  local base_dir
  local total
  local target

  base_dir="$(dirname -- "${file}")"
  total="$(wc -c <"${file}")"
  while IFS= read -r target; do
    if [[ -z "${target}" ]]; then
      continue
    fi
    if [[ ! -f "${base_dir}/${target}" ]]; then
      echo "${file}: missing import -> ${target}" >&2
      return 1
    fi
    total=$((total + $(wc -c <"${base_dir}/${target}")))
  done < <(rule_imports "${file}")

  echo "${total}"
}

# check_rule_budget <rule-file> <byte-limit>
check_rule_budget() {
  local file="$1"
  local limit="$2"
  local size

  size="$(expanded_rule_size "${file}")" || return 1
  echo "${file##*/}: ${size} bytes after import expansion (limit ${limit})"
  [[ "${size}" -le "${limit}" ]]
}

# check_no_issue_scoped_commits <path>...
# Fails if any commit template uses an issue number as its scope
# (git commit -m "feat(#42): ..."). Issue references belong to the merge
# commit, which git-brx writes.
check_no_issue_scoped_commits() {
  local matches

  matches="$(grep -rnE 'git commit .*-m "[a-z]+\(#' "$@" || true)"
  if [[ -n "${matches}" ]]; then
    echo "commit template with an issue-number scope:" >&2
    echo "${matches}" >&2
    return 1
  fi
}

# check_no_gh_calls <path>...
# Fails if any file calls the GitHub CLI (gh <subcommand>). Words that merely
# contain "gh" (high, through) don't match.
check_no_gh_calls() {
  local matches

  matches="$(grep -rnE '(^|[^[:alnum:]_-])gh [a-z]+' "$@" || true)"
  if [[ -n "${matches}" ]]; then
    echo "GitHub CLI call (keep the plugin platform-neutral):" >&2
    echo "${matches}" >&2
    return 1
  fi
}

# check_permission_line <skill-file>
# Fails unless <skill-file> contains exactly one '- **Permission:**' line.
check_permission_line() {
  local file="$1"
  local count

  count="$(grep -cE '^- \*\*Permission:\*\* ' "${file}" || true)"
  if [[ "${count}" -eq 0 ]]; then
    echo "${file}: missing '- **Permission:**' line" >&2
    return 1
  fi
  if [[ "${count}" -gt 1 ]]; then
    echo "${file}: multiple '- **Permission:**' lines (${count})" >&2
    return 1
  fi
}

# check_no_default_branch_push <path>...
# Fails if any file proposes pushing directly to main or master.
check_no_default_branch_push() {
  local matches

  matches="$(grep -rnE 'git push([[:space:]]+[^[:space:]]+)*[[:space:]]+(main|master)([[:space:]]|$)' "$@" || true)"
  if [[ -n "${matches}" ]]; then
    echo "command proposes pushing the default branch:" >&2
    echo "${matches}" >&2
    return 1
  fi
}

# check_tone_reference <skill-file>
# Fails unless <skill-file> includes the canonical tone fragment reference line.
check_tone_reference() {
  local file="$1"
  local expected='- **Tone:** Follow [strict-technical-tone.md](../../fragments/strict-technical-tone.md).'

  if ! grep -qxF -- "${expected}" "${file}"; then
    echo "${file}: missing canonical tone reference '${expected}'" >&2
    return 1
  fi
}
