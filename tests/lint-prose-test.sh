#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
WRAPPER="$REPO_ROOT/scripts/lint-prose.sh"
TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/lint-prose-test.XXXXXX")"
trap 'rm -rf "$TEMP_DIR"' EXIT

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

expect_success() {
  if ! "$@"; then
    fail "expected success: $*"
  fi
}

expect_failure() {
  if "$@" >/dev/null 2>&1; then
    fail "expected failure: $*"
  fi
}

expect_contains() {
  local needle="$1"
  local file="$2"
  if ! grep -Fq -- "$needle" "$file"; then
    fail "expected '$needle' in $file"
  fi
}

FAKE_BIN="$TEMP_DIR/bin"
FAKE_LOG="$TEMP_DIR/fake-vale.log"
EXPECTED_LOG="$TEMP_DIR/expected-vale.log"
mkdir -p "$FAKE_BIN"
printf '%s\n' '#!/usr/bin/env bash' \
  'set -euo pipefail' \
  'printf "%s\\n" "$@" > "$FAKE_VALE_LOG"' \
  'exit "${FAKE_VALE_EXIT:-0}"' > "$FAKE_BIN/vale"
chmod +x "$FAKE_BIN/vale"

run_fake() {
  PATH="$FAKE_BIN:$PATH" FAKE_VALE_LOG="$FAKE_LOG" "$@"
}

assert_argv() {
  printf '%s\n' "$@" > "$EXPECTED_LOG"
  if ! cmp -s "$EXPECTED_LOG" "$FAKE_LOG"; then
    diff -u "$EXPECTED_LOG" "$FAKE_LOG" >&2 || true
    fail "Vale arguments differed from the expected profile routing"
  fi
}

expect_success run_fake "$WRAPPER" --profile repository
assert_argv \
  --config "$REPO_ROOT/tools/vale/.vale.ini" -- \
  "$REPO_ROOT/README.md" \
  "$REPO_ROOT/CONTRIBUTING.md" \
  "$REPO_ROOT/CODE_OF_CONDUCT.md" \
  "$REPO_ROOT/SECURITY.md" \
  "$REPO_ROOT/docs" \
  "$REPO_ROOT/skills" \
  "$REPO_ROOT/shared" \
  "$REPO_ROOT/examples" \
  "$REPO_ROOT/tests/manual"

SPACE_TARGET="$TEMP_DIR/personal draft.md"
printf '%s\n' 'A personal draft.' > "$SPACE_TARGET"
expect_success run_fake "$WRAPPER" "$SPACE_TARGET"
assert_argv --config "$REPO_ROOT/tools/vale/.vale-engineering.ini" -- "$SPACE_TARGET"

expect_success run_fake "$WRAPPER" --profile engineering -- "$SPACE_TARGET"
assert_argv --config "$REPO_ROOT/tools/vale/.vale-engineering.ini" -- "$SPACE_TARGET"

DASH_TARGET='-personal draft.md'
printf '%s\n' 'A personal draft.' > "$TEMP_DIR/$DASH_TARGET"
(
  cd "$TEMP_DIR"
  expect_success run_fake "$WRAPPER" --profile personal -- "$DASH_TARGET"
)
assert_argv --config "$REPO_ROOT/tools/vale/.vale-personal.ini" -- "$DASH_TARGET"

# This is the routing mutation oracle: mutate a disposable wrapper so its
# personal branch selects engineering, then prove the normal config oracle
# rejects the resulting Vale invocation.
MUTATION_ROOT="$TEMP_DIR/routing-mutation"
MUTATED_WRAPPER="$MUTATION_ROOT/scripts/lint-prose.sh"
mkdir -p "$MUTATION_ROOT/scripts" "$MUTATION_ROOT/tools/vale"
sed 's|tools/vale/.vale-personal.ini|tools/vale/.vale-engineering.ini|' "$WRAPPER" > "$MUTATED_WRAPPER"
cp "$REPO_ROOT/tools/vale/.vale-engineering.ini" "$REPO_ROOT/tools/vale/.vale-personal.ini" "$MUTATION_ROOT/tools/vale/"
chmod +x "$MUTATED_WRAPPER"
expect_success run_fake "$MUTATED_WRAPPER" --profile personal -- "$SPACE_TARGET"
if (assert_argv --config "$MUTATION_ROOT/tools/vale/.vale-personal.ini" -- "$SPACE_TARGET") >/dev/null 2>&1; then
  fail "routing mutation was not detected"
fi

expect_failure run_fake "$WRAPPER" --profile engineering
expect_failure run_fake "$WRAPPER" --profile unknown -- "$SPACE_TARGET"
expect_failure run_fake "$WRAPPER" --profile repository -- "$SPACE_TARGET"
expect_failure run_fake "$WRAPPER" --profile personal -- "$TEMP_DIR/missing.md"
expect_failure env PATH="$FAKE_BIN:$PATH" FAKE_VALE_LOG="$FAKE_LOG" FAKE_VALE_EXIT=7 "$WRAPPER" --profile personal -- "$SPACE_TARGET"
expect_failure env PATH="/usr/bin:/bin" "$WRAPPER" --profile personal -- "$SPACE_TARGET"

MISSING_CONFIG_WRAPPER="$TEMP_DIR/missing-config/scripts/lint-prose.sh"
mkdir -p "$(dirname "$MISSING_CONFIG_WRAPPER")"
cp "$WRAPPER" "$MISSING_CONFIG_WRAPPER"
chmod +x "$MISSING_CONFIG_WRAPPER"
expect_failure run_fake "$MISSING_CONFIG_WRAPPER" --profile personal -- "$SPACE_TARGET"

if ! command -v vale >/dev/null 2>&1; then
  fail "real Vale is required for the profile probes"
fi

ENGINEERING_SAMPLE="$TEMP_DIR/engineering.md"
PERSONAL_SAMPLE="$TEMP_DIR/personal.md"
printf '%s\n' '# Key takeaways' 'This is a strategic effort.' > "$ENGINEERING_SAMPLE"
printf '%s\n' \
  'What I concluded is that I set up an e-mail routine. This is the point.' \
  'This is a strategic effort.' > "$PERSONAL_SAMPLE"

ENGINEERING_OUTPUT="$TEMP_DIR/engineering.out"
if "$WRAPPER" --profile engineering -- "$ENGINEERING_SAMPLE" >"$ENGINEERING_OUTPUT" 2>&1; then
  fail "engineering profile accepted a known error"
fi
expect_contains 'AgentVoice.PolishedHeadings' "$ENGINEERING_OUTPUT"

PERSONAL_OUTPUT="$TEMP_DIR/personal.out"
expect_success "$WRAPPER" --profile personal -- "$PERSONAL_SAMPLE" >"$PERSONAL_OUTPUT" 2>&1
expect_contains 'AgentVoice.CorporateFiller' "$PERSONAL_OUTPUT"
for rule in AuthorState MirroredRhythm PlainVerbs TermDrift; do
  if grep -Fq -- "AgentVoice.$rule" "$PERSONAL_OUTPUT"; then
    fail "personal profile inherited AgentVoice.$rule"
  fi
done

printf '%s\n' 'lint-prose tests passed'
