#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
MANIFEST="$REPO_ROOT/skills/manifest.tsv"
RETIRED_MANIFEST="$REPO_ROOT/skills/retired.tsv"

fail() {
  printf 'Validation failed: %s\n' "$*" >&2
  exit 1
}

[ -f "$MANIFEST" ] || fail "missing skills/manifest.tsv"
[ -f "$RETIRED_MANIFEST" ] || fail "missing skills/retired.tsv"

names_file="$(mktemp "${TMPDIR:-/tmp}/agent-skills-names.XXXXXX")"
dirs_file="$(mktemp "${TMPDIR:-/tmp}/agent-skills-dirs.XXXXXX")"
cleanup() { rm -f "$names_file" "$dirs_file"; }
trap cleanup EXIT

for declaration_file in "$MANIFEST" "$RETIRED_MANIFEST"; do
  while IFS=$'\t' read -r skill_name skill_description remainder; do
    case "$skill_name" in ''|'#'*) continue ;; esac
    [ -n "$skill_description" ] || fail "entry '$skill_name' in $(basename "$declaration_file") has no description"
    [ -z "${remainder:-}" ] || fail "entry '$skill_name' in $(basename "$declaration_file") has more than two columns"
    case "$skill_name" in *[!a-z0-9-]*|-*|*-) fail "invalid skill name '$skill_name'" ;; esac
    grep -Fxq "$skill_name" "$names_file" && fail "duplicate skill declaration '$skill_name'"
    printf '%s\n' "$skill_name" >> "$names_file"
    skill_file="$REPO_ROOT/skills/$skill_name/SKILL.md"
    [ -f "$skill_file" ] || fail "missing skills/$skill_name/SKILL.md"
    version_file="$REPO_ROOT/skills/$skill_name/VERSION"
    [ -f "$version_file" ] || fail "missing skills/$skill_name/VERSION"
    skill_version="$(tr -d '\r\n' < "$version_file")"
    case "$skill_version" in
      ''|*[!0-9.]*) fail "invalid version '$skill_version' for '$skill_name'" ;;
    esac
    printf '%s\n' "$skill_version" | awk -F. 'NF == 3 && $1 ~ /^(0|[1-9][0-9]*)$/ && $2 ~ /^(0|[1-9][0-9]*)$/ && $3 ~ /^(0|[1-9][0-9]*)$/ { found=1 } END { exit found ? 0 : 1 }' || fail "version '$skill_version' for '$skill_name' must use MAJOR.MINOR.PATCH"
    frontmatter_name="$(awk 'NR == 1 && $0 != "---" { exit 2 } NR > 1 && $0 == "---" { exit } NR > 1 && /^name:[[:space:]]*/ { sub(/^name:[[:space:]]*/, ""); print; exit }' "$skill_file")" || fail "invalid frontmatter in skills/$skill_name/SKILL.md"
    [ "$frontmatter_name" = "$skill_name" ] || fail "folder '$skill_name' does not match frontmatter name '$frontmatter_name'"
    version_occurrences="$(grep -Foc "Version $skill_version" "$skill_file" || true)"
    [ "$version_occurrences" -eq 1 ] || fail "description for '$skill_name' must contain 'Version $skill_version' exactly once"
    body_occurrences="$(grep -Foc "**Version: $skill_version.**" "$skill_file" || true)"
    [ "$body_occurrences" -eq 1 ] || fail "body for '$skill_name' must contain '**Version: $skill_version.**' exactly once"
  done < "$declaration_file"
done

[ -s "$names_file" ] || fail "manifest has no skills"
find "$REPO_ROOT/skills" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort > "$dirs_file"
sort -o "$names_file" "$names_file"
if ! diff -u "$names_file" "$dirs_file" >/dev/null; then
  diff -u "$names_file" "$dirs_file" >&2 || true
  fail "active and retired declarations do not match skill directories"
fi

printf 'Validated %s skills.\n' "$(wc -l < "$names_file" | tr -d ' ')"
