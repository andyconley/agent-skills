#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

if ! command -v ruby >/dev/null 2>&1; then
  printf 'FAIL: Ruby is required for YAML-backed workbreakdown contract tests.\n' >&2
  exit 127
fi

exec ruby "$REPO_ROOT/tests/workbreakdown/workbreakdown-template-contract-test.rb"
