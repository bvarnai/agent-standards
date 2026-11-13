#!/usr/bin/env bats
# Static check: every skill declares valid frontmatter.

setup() {
  load helpers
}

# write_skill <content>: writes demo/SKILL.md in the per-test temp dir.
write_skill() {
  mkdir -p "${BATS_TEST_TMPDIR}/demo"
  printf '%s\n' "$1" >"${BATS_TEST_TMPDIR}/demo/SKILL.md"
}

@test "every skill has a name matching its directory and a description" {
  local file
  local count=0
  local failures=0

  for file in "${REPO_ROOT}"/skills/*/SKILL.md; do
    count=$((count + 1))
    check_frontmatter "${file}" "$(basename "$(dirname "${file}")")" \
      || failures=$((failures + 1))
  done

  assert [ "${count}" -gt 0 ]
  assert_equal "${failures}" 0
}

@test "frontmatter check accepts a valid skill, including a quoted name" {
  write_skill $'---\nname: "demo"\ndescription: Does a thing.\n---\n# Demo'
  run check_frontmatter "${BATS_TEST_TMPDIR}/demo/SKILL.md" demo
  assert_success
}

@test "frontmatter check rejects a missing name" {
  write_skill $'---\ndescription: Does a thing.\n---\n# Demo'
  run check_frontmatter "${BATS_TEST_TMPDIR}/demo/SKILL.md" demo
  assert_failure
  assert_output --partial "no name"
}

@test "frontmatter check rejects a missing description" {
  write_skill $'---\nname: demo\n---\n# Demo'
  run check_frontmatter "${BATS_TEST_TMPDIR}/demo/SKILL.md" demo
  assert_failure
  assert_output --partial "no description"
}

@test "frontmatter check rejects a name that differs from the directory" {
  write_skill $'---\nname: other\ndescription: Does a thing.\n---\n# Demo'
  run check_frontmatter "${BATS_TEST_TMPDIR}/demo/SKILL.md" demo
  assert_failure
  assert_output --partial "does not match directory"
}

@test "frontmatter check rejects a file without frontmatter" {
  write_skill $'# Demo\n\nname: demo'
  run check_frontmatter "${BATS_TEST_TMPDIR}/demo/SKILL.md" demo
  assert_failure
  assert_output --partial "missing opening"
}

@test "frontmatter check rejects unclosed frontmatter" {
  write_skill $'---\nname: demo\ndescription: Does a thing.\n# Demo'
  run check_frontmatter "${BATS_TEST_TMPDIR}/demo/SKILL.md" demo
  assert_failure
  assert_output --partial "not closed"
}
