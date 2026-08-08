#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/agent-skills-test.XXXXXX")"
cleanup() { rm -rf "$TEST_ROOT"; }
trap cleanup EXIT

pass_count=0
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
pass() { pass_count=$((pass_count + 1)); printf 'ok %s - %s\n' "$pass_count" "$1"; }
assert_link() { [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ] || fail "expected $1 -> $2"; }
assert_missing() { [ ! -e "$1" ] && [ ! -L "$1" ] || fail "expected $1 to be absent"; }

run_manager() {
  AGENT_SKILLS_CODEX_DIR="$TEST_ROOT/codex" \
  AGENT_SKILLS_CLAUDE_DIR="$TEST_ROOT/claude" \
  "$REPO_ROOT/scripts/manage-skills.sh" "$@"
}

run_manager_path() {
  local path_value="$1"
  shift
  AGENT_SKILLS_CODEX_DIR="$TEST_ROOT/codex" \
  AGENT_SKILLS_CLAUDE_DIR="$TEST_ROOT/claude" \
  PATH="$path_value" \
  "$REPO_ROOT/scripts/manage-skills.sh" "$@"
}

"$REPO_ROOT/scripts/validate-skills.sh" >/dev/null
pass "manifest validates"

empty_root="$TEST_ROOT/empty"
mkdir -p "$empty_root"
AGENT_SKILLS_CODEX_DIR="$empty_root/codex" \
AGENT_SKILLS_CLAUDE_DIR="$empty_root/claude" \
"$REPO_ROOT/scripts/manage-skills.sh" </dev/null >"$empty_root/out" 2>"$empty_root/err"
[ ! -s "$empty_root/err" ] || fail "empty selection wrote an error"
assert_missing "$empty_root/codex"
assert_missing "$empty_root/claude"
pass "empty interactive selection cancels without changes"

run_manager --skill humanizer >/dev/null
assert_link "$TEST_ROOT/codex/humanizer" "$REPO_ROOT/skills/humanizer"
assert_link "$TEST_ROOT/claude/humanizer" "$REPO_ROOT/skills/humanizer"
assert_missing "$TEST_ROOT/codex/doc-flow-review"
pass "one skill installs to both runtimes"

run_manager --skill humanizer >/dev/null
assert_link "$TEST_ROOT/codex/humanizer" "$REPO_ROOT/skills/humanizer"
pass "repeat install is idempotent"

run_manager --all >/dev/null
assert_link "$TEST_ROOT/codex/doc-flow-review" "$REPO_ROOT/skills/doc-flow-review"
assert_link "$TEST_ROOT/claude/doc-flow-review" "$REPO_ROOT/skills/doc-flow-review"
pass "all installs every declared skill"

touch "$TEST_ROOT/codex/unrelated"
run_manager --all >/dev/null
[ -f "$TEST_ROOT/codex/unrelated" ] || fail "unrelated skill was removed"
pass "unrelated targets are preserved"

run_manager --uninstall --skill humanizer >/dev/null
assert_missing "$TEST_ROOT/codex/humanizer"
assert_missing "$TEST_ROOT/claude/humanizer"
assert_link "$TEST_ROOT/codex/doc-flow-review" "$REPO_ROOT/skills/doc-flow-review"
[ -f "$TEST_ROOT/codex/unrelated" ] || fail "uninstall removed unrelated target"
pass "selected uninstall is narrow"

run_manager --uninstall --skill humanizer >/dev/null
pass "repeat uninstall is idempotent"

mkdir -p "$TEST_ROOT/codex/humanizer"
if run_manager --skill humanizer >"$TEST_ROOT/conflict.out" 2>&1; then
  fail "directory conflict should stop installation"
fi
assert_missing "$TEST_ROOT/claude/humanizer"
pass "preflight prevents partial install on directory conflict"
rmdir "$TEST_ROOT/codex/humanizer"

ln -s "$TEST_ROOT/not-the-repo" "$TEST_ROOT/claude/humanizer"
if run_manager --skill humanizer >"$TEST_ROOT/wrong-link.out" 2>&1; then
  fail "wrong symlink should stop installation"
fi
assert_missing "$TEST_ROOT/codex/humanizer"
pass "wrong symlink stops installation"
rm "$TEST_ROOT/claude/humanizer"

run_manager --skill humanizer >/dev/null
rm "$TEST_ROOT/claude/humanizer"
mkdir "$TEST_ROOT/claude/humanizer"
if run_manager --uninstall --skill humanizer >"$TEST_ROOT/uninstall-conflict.out" 2>&1; then
  fail "uninstall conflict should stop removal"
fi
assert_link "$TEST_ROOT/codex/humanizer" "$REPO_ROOT/skills/humanizer"
pass "uninstall preflight prevents partial removal"
rmdir "$TEST_ROOT/claude/humanizer"

run_manager --uninstall --all >/dev/null
missing_vale_path="/usr/bin:/bin:/usr/sbin:/sbin"
run_manager_path "$missing_vale_path" --all --no-vale >"$TEST_ROOT/no-vale.out" 2>&1
assert_link "$TEST_ROOT/codex/humanizer" "$REPO_ROOT/skills/humanizer"
assert_link "$TEST_ROOT/codex/doc-flow-review" "$REPO_ROOT/skills/doc-flow-review"
pass "no-vale skips dependency handling"

run_manager --uninstall --all >/dev/null
if run_manager_path "$missing_vale_path" --all --with-vale >"$TEST_ROOT/with-vale-missing.out" 2>&1; then
  fail "--with-vale should fail without Vale or supported installer"
fi
assert_missing "$TEST_ROOT/codex/humanizer"
assert_missing "$TEST_ROOT/claude/humanizer"
pass "with-vale fails clearly when unsupported"

fakebin="$TEST_ROOT/fakebin"
mkdir -p "$fakebin"
cat >"$fakebin/brew" <<EOF
#!/usr/bin/env bash
set -euo pipefail
[ "\$1" = "install" ] && [ "\$2" = "vale" ]
cat >"$fakebin/vale" <<'VALE'
#!/usr/bin/env bash
printf 'vale version test\n'
VALE
chmod +x "$fakebin/vale"
EOF
chmod +x "$fakebin/brew"
run_manager_path "$fakebin:$missing_vale_path" --skill humanizer --with-vale >"$TEST_ROOT/with-vale.out" 2>&1
assert_link "$TEST_ROOT/codex/humanizer" "$REPO_ROOT/skills/humanizer"
grep -Fq 'Vale installed: vale version test' "$TEST_ROOT/with-vale.out" || fail "with-vale did not install mocked Vale"
pass "with-vale installs through supported package manager"

if run_manager --uninstall --with-vale --skill humanizer >"$TEST_ROOT/uninstall-with-vale.out" 2>&1; then
  fail "--with-vale should not be accepted with uninstall"
fi
pass "with-vale is rejected for uninstall"

if run_manager --all --with-vale --no-vale >"$TEST_ROOT/vale-conflict.out" 2>&1; then
  fail "--with-vale and --no-vale should conflict"
fi
pass "vale flags are mutually exclusive"

printf '1..%s\n' "$pass_count"
