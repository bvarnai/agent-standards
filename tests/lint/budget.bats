#!/usr/bin/env bats
# Static check: always-on rules stay within the Antigravity rule size cap.

# Antigravity truncates each rule file at 24,000 bytes after expanding
# @[label](path) imports. Source: https://antigravity.google/docs/rules-workflows
# ("Size limits and token budgets").
readonly RULE_BYTE_LIMIT=24000

setup() {
  load helpers
  RULE="${BATS_TEST_TMPDIR}/GEMINI.md"
}

@test "always-on rules stay within the rule byte limit" {
  run check_rule_budget "${REPO_ROOT}/rules/GEMINI.md" "${RULE_BYTE_LIMIT}"
  echo "# ${output}" >&3
  assert_success
}

@test "budget check counts imported files" {
  printf '%s\n' '@[Big](./big.md)' >"${RULE}"
  head -c 25000 /dev/zero | tr '\0' 'a' >"${BATS_TEST_TMPDIR}/big.md"
  run check_rule_budget "${RULE}" "${RULE_BYTE_LIMIT}"
  assert_failure
  assert_output --partial "limit ${RULE_BYTE_LIMIT}"
}

@test "budget check fails on a missing import" {
  printf '%s\n' '@[Gone](./gone.md)' >"${RULE}"
  run check_rule_budget "${RULE}" "${RULE_BYTE_LIMIT}"
  assert_failure
  assert_output --partial "missing import"
}
