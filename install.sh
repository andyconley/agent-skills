#!/usr/bin/env bash
set -euo pipefail

REPOSITORY_URL="${AGENT_SKILLS_REPO_URL:-https://github.com/andyconley/agent-skills.git}"
CHECKOUT_DIR="${AGENT_SKILLS_HOME:-$HOME/agent-skills}"
SCRIPT_LOCATION="${BASH_SOURCE[0]:-}"

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

canonical_origin() {
  printf '%s\n' "$1" | sed -e 's#^git@github.com:#https://github.com/#' -e 's#\.git$##' -e 's#/*$##'
}

update_checkout() {
  local checkout="$1"
  local actual_origin

  [ -d "$checkout/.git" ] || fail "$checkout exists but is not a Git checkout. Move it or set AGENT_SKILLS_HOME."
  actual_origin="$(git -C "$checkout" remote get-url origin 2>/dev/null || true)"
  [ -n "$actual_origin" ] || fail "$checkout has no origin remote."
  if [ "$(canonical_origin "$actual_origin")" != "$(canonical_origin "$REPOSITORY_URL")" ]; then
    fail "$checkout points to $actual_origin, not $REPOSITORY_URL. No changes made."
  fi
  [ -z "$(git -C "$checkout" status --porcelain)" ] || fail "$checkout has local changes. Commit or move them before installing."
  git -C "$checkout" pull --ff-only
}

script_dir=""
if [ -n "$SCRIPT_LOCATION" ] && [ -f "$SCRIPT_LOCATION" ]; then
  script_dir="$(cd "$(dirname "$SCRIPT_LOCATION")" && pwd -P)"
fi

if [ -n "$script_dir" ] && [ -d "$script_dir/.git" ] && [ -f "$script_dir/skills/manifest.tsv" ]; then
  CHECKOUT_DIR="$script_dir"
  update_checkout "$CHECKOUT_DIR"
else
  if [ -e "$CHECKOUT_DIR" ]; then
    update_checkout "$CHECKOUT_DIR"
  else
    parent_dir="$(dirname "$CHECKOUT_DIR")"
    mkdir -p "$parent_dir"
    git clone "$REPOSITORY_URL" "$CHECKOUT_DIR"
  fi
fi

exec "$CHECKOUT_DIR/scripts/manage-skills.sh" "$@"
