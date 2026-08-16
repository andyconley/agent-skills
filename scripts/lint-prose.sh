#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
CONFIG="$REPO_ROOT/tools/vale/.vale.ini"

if ! command -v vale >/dev/null 2>&1; then
  cat >&2 <<'EOF'
Error: Vale is not installed or not on PATH.

Install Vale, then retry:
  brew install vale
  # or see tools/vale/README.md
EOF
  exit 127
fi

if [ "$#" -gt 0 ]; then
  exec vale --config "$CONFIG" "$@"
fi

exec vale --config "$CONFIG" \
  "$REPO_ROOT/README.md" \
  "$REPO_ROOT/CONTRIBUTING.md" \
  "$REPO_ROOT/CODE_OF_CONDUCT.md" \
  "$REPO_ROOT/SECURITY.md" \
  "$REPO_ROOT/docs" \
  "$REPO_ROOT/skills" \
  "$REPO_ROOT/shared" \
  "$REPO_ROOT/examples" \
  "$REPO_ROOT/tests/manual"
