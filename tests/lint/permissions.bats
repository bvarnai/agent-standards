#!/usr/bin/env bats
# Static checks: skill Permission declarations and default-branch push ban.

setup() {
  load helpers
  DOC="${BATS_TEST_TMPDIR}/doc.md"
}

@test "every skill declares exactly one Permission line" {
  local skill
  for skill in "${REPO_ROOT}"/skills/*/SKILL.md; do
    run check_permission_line "${skill}"
    assert_success
  done
}

@test "no rule or skill proposes pushing the default branch" {
  run check_no_default_branch_push "${REPO_ROOT}/rules" "${REPO_ROOT}/skills"
  assert_success
}

@test "permission check fails when a skill has no Permission line" {
  printf '%s\n' '## Constraints' '- Follow strict tone.' >"${DOC}"
  run check_permission_line "${DOC}"
  assert_failure
  assert_output --partial "missing"
}

@test "permission check fails when a skill has two Permission lines" {
  printf '%s\n' '- **Permission:** None.' '- **Permission:** Edit foo.' >"${DOC}"
  run check_permission_line "${DOC}"
  assert_failure
  assert_output --partial "multiple"
}

@test "default-branch push check fails on git push origin main" {
  printf '%s\n' 'git push origin main --follow-tags' >"${DOC}"
  run check_no_default_branch_push "${DOC}"
  assert_failure
  assert_output --partial "default branch"
}

@test "default-branch push check ignores tag pushes and prose" {
  printf '%s\n' 'git push origin vX.Y.Z' \
    'Never push to the main branch directly.' >"${DOC}"
  run check_no_default_branch_push "${DOC}"
  assert_success
}
