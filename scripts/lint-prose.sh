#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

usage() {
  cat <<'EOF'
Usage: scripts/lint-prose.sh [--profile repository|engineering|personal] [--] [file-or-directory ...]

Profiles:
  repository   Lint the repository's governing prose targets (default).
  engineering  Lint explicit engineering-writing targets with blocking rules.
  personal     Lint explicit personal-writing targets with advisory rules.

Engineering and personal profiles require at least one explicit target. Use --
before targets that begin with a dash.

A bare target without --profile uses the engineering profile for existing
strict skill callers. Prefer an explicit profile in new callers.
EOF
}

profile="repository"
profile_explicit=false
declare -a targets=()
parsing_options=true

while [ "$#" -gt 0 ]; do
  if "$parsing_options"; then
    case "$1" in
      --help|-h)
        usage
        exit 0
        ;;
      --profile)
        if [ "$#" -lt 2 ]; then
          printf '%s\n' "Error: --profile requires repository, engineering, or personal." >&2
          exit 2
        fi
        profile="$2"
        profile_explicit=true
        shift 2
        continue
        ;;
      --profile=*)
        profile="${1#--profile=}"
        profile_explicit=true
        ;;
      --)
        parsing_options=false
        shift
        continue
        ;;
      -*)
        printf 'Error: unknown option: %s\n' "$1" >&2
        usage >&2
        exit 2
        ;;
      *)
        targets+=("$1")
        ;;
    esac
  else
    targets+=("$1")
  fi
  shift
done

if [ "$profile_explicit" = false ] && [ "${#targets[@]}" -gt 0 ]; then
  profile="engineering"
fi

case "$profile" in
  repository) config="$REPO_ROOT/tools/vale/.vale.ini" ;;
  engineering) config="$REPO_ROOT/tools/vale/.vale-engineering.ini" ;;
  personal) config="$REPO_ROOT/tools/vale/.vale-personal.ini" ;;
  *)
    printf 'Error: unknown profile: %s\n' "$profile" >&2
    usage >&2
    exit 2
    ;;
esac

if [ "$profile" != "repository" ] && [ "${#targets[@]}" -eq 0 ]; then
  printf 'Error: the %s profile requires at least one explicit target.\n' "$profile" >&2
  exit 2
fi

if [ "$profile" = "repository" ] && [ "${#targets[@]}" -gt 0 ]; then
  printf '%s\n' "Error: the repository profile has a fixed target set; use engineering or personal for explicit targets." >&2
  exit 2
fi

if [ ! -f "$config" ]; then
  printf 'Error: Vale config is missing: %s\n' "$config" >&2
  exit 3
fi

if [ "${#targets[@]}" -eq 0 ]; then
  targets=(
    "$REPO_ROOT/README.md"
    "$REPO_ROOT/CONTRIBUTING.md"
    "$REPO_ROOT/CODE_OF_CONDUCT.md"
    "$REPO_ROOT/SECURITY.md"
    "$REPO_ROOT/docs"
    "$REPO_ROOT/skills"
    "$REPO_ROOT/shared"
    "$REPO_ROOT/examples"
    "$REPO_ROOT/tests/manual"
  )
fi

for target in "${targets[@]}"; do
  if [ ! -e "$target" ]; then
    printf 'Error: lint target does not exist: %s\n' "$target" >&2
    exit 2
  fi
done

if ! command -v vale >/dev/null 2>&1; then
  cat >&2 <<'EOF'
Error: Vale is not installed or not on PATH.

Install Vale, then retry:
  brew install vale
  # or see tools/vale/README.md
EOF
  exit 127
fi

exec vale --config "$config" -- "${targets[@]}"
