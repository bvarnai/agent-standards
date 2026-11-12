#!/usr/bin/env bats
# Static check: every relative link and @-import in the plugin resolves.

setup() {
  load helpers
  DOC="${BATS_TEST_TMPDIR}/doc.md"
}

@test "every relative link and @-import in the plugin resolves" {
  local file
  local count=0
  local failures=0

  while IFS= read -r file; do
    count=$((count + 1))
    check_links "${file}" || failures=$((failures + 1))
  done < <(markdown_files)

  assert [ "${count}" -gt 0 ]
  assert_equal "${failures}" 0
}

@test "link check fails on a broken relative link" {
  printf '%s\n' 'See [missing](./missing.md).' >"${DOC}"
  run check_links "${DOC}"
  assert_failure
  assert_output --partial "broken link -> ./missing.md"
}

@test "link check fails on a broken @-import" {
  printf '%s\n' '@[Rules](./missing-rules.md)' >"${DOC}"
  run check_links "${DOC}"
  assert_failure
}

@test "link check strips #anchor suffixes" {
  printf '%s\n' '# Target' >"${BATS_TEST_TMPDIR}/target.md"
  printf '%s\n' 'See [target](./target.md#target) and [self](#top).' >"${DOC}"
  run check_links "${DOC}"
  assert_success
}

@test "link check ignores links inside fenced code blocks" {
  printf '%s\n' 'Text' '```markdown' '[example](./not-there.md)' '```' >"${DOC}"
  run check_links "${DOC}"
  assert_success
}

@test "link check ignores inline code and external links" {
  printf '%s\n' 'Use `[x](./not-there.md)` or [site](https://example.com/a).' >"${DOC}"
  run check_links "${DOC}"
  assert_success
}
