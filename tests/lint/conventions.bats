#!/usr/bin/env bats
# Static checks: commit and platform conventions in rules and skills.

setup() {
  load helpers
  DOC="${BATS_TEST_TMPDIR}/doc.md"
}

@test "no commit template in skills uses an issue-number scope" {
  run check_no_issue_scoped_commits "${REPO_ROOT}/skills"
  assert_success
}

@test "no rule or skill calls the GitHub CLI" {
  run check_no_gh_calls "${REPO_ROOT}/rules" "${REPO_ROOT}/skills"
  assert_success
}

@test "issue-scope check fails on a commit template with (#id)" {
  printf '%s\n' 'git commit -m "feat(#42): add flag" -m "Closes #42"' >"${DOC}"
  run check_no_issue_scoped_commits "${DOC}"
  assert_failure
  assert_output --partial "issue-number scope"
}

@test "issue-scope check accepts a component scope" {
  printf '%s\n' 'git commit -m "<type>(<component>): <summary>"' \
    'git commit -m "chore(release): cut vX.Y.Z"' >"${DOC}"
  run check_no_issue_scoped_commits "${DOC}"
  assert_success
}

@test "issue-scope check ignores changelog issue links" {
  printf '%s\n' '- Fixed a crash on empty input (`#42`)' \
    'Move entries, preserving (`#<id>`) issue references.' >"${DOC}"
  run check_no_issue_scoped_commits "${DOC}"
  assert_success
}

@test "gh check fails on a GitHub CLI call" {
  printf '%s\n' 'Run `gh issue create --body-file .issue-draft.md`.' >"${DOC}"
  run check_no_gh_calls "${DOC}"
  assert_failure
  assert_output --partial "GitHub CLI call"
}

@test "gh check ignores words that contain gh" {
  printf '%s\n' 'Use high effort and go through it thoroughly.' \
    'High-recall cross-checking (see the GitHub Flavored Markdown spec).' >"${DOC}"
  run check_no_gh_calls "${DOC}"
  assert_success
}
