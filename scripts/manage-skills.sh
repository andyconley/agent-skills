#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
MANIFEST="$REPO_ROOT/skills/manifest.tsv"
CODEX_DIR="${AGENT_SKILLS_CODEX_DIR:-$HOME/.agents/skills}"
CLAUDE_DIR="${AGENT_SKILLS_CLAUDE_DIR:-$HOME/.claude/skills}"
MODE="install"
SELECT_ALL=0
VALE_MODE="prompt"
VALE_OPTION_SET=0
SELECTED_SKILLS=()

usage() {
  cat <<'EOF'
Usage: ./install.sh [--all | --skill NAME ...] [--uninstall] [--with-vale | --no-vale]

Without a selection option, the installer prompts for skills. It installs to
both Codex (~/.agents/skills) and Claude Code (~/.claude/skills).

Options:
  --all           Select every skill in the manifest.
  --skill NAME    Select one skill. Repeat for more than one.
  --uninstall     Remove selected repo-controlled symlinks.
  --with-vale     Install Vale if it is missing. Fails if no supported installer is found.
  --no-vale       Skip Vale dependency handling.
  --help          Show this help.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

vale_install_help() {
  cat <<'EOF'
Vale is optional, but enables strict-mode prose linting.

Install it manually with:
  brew install vale

Then verify:
  vale --version
  ./scripts/lint-prose.sh
EOF
}

install_vale() {
  if command -v vale >/dev/null 2>&1; then
    printf 'Vale already installed: %s\n' "$(vale --version)"
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    printf 'Installing Vale with Homebrew...\n'
    brew install vale
    printf 'Vale installed: %s\n' "$(vale --version)"
    return 0
  fi

  vale_install_help >&2
  return 1
}

maybe_install_vale() {
  [ "$MODE" = "install" ] || return 0

  case "$VALE_MODE" in
    skip) return 0 ;;
    install)
      install_vale || fail "could not install Vale"
      ;;
    prompt)
      if command -v vale >/dev/null 2>&1; then
        printf 'Vale already installed: %s\n' "$(vale --version)"
        return 0
      fi
      if ( : </dev/tty ) 2>/dev/null; then
        printf 'Vale is optional but enables strict-mode prose linting. Install it now? [y/N] '
        answer=""
        IFS= read -r answer < /dev/tty || true
        case "$answer" in
          y|Y|yes|YES|Yes) install_vale || fail "could not install Vale" ;;
          *) printf 'Skipped Vale. Run ./install.sh --with-vale later to install it.\n' ;;
        esac
      else
        printf 'Vale is optional and not installed. Run ./install.sh --with-vale to enable strict-mode linting.\n'
      fi
      ;;
    *) fail "internal error: unknown Vale mode '$VALE_MODE'" ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --all) SELECT_ALL=1 ;;
    --skill)
      shift
      [ "$#" -gt 0 ] || fail "--skill requires a name"
      SELECTED_SKILLS+=("$1")
      ;;
    --uninstall) MODE="uninstall" ;;
    --with-vale)
      [ "$VALE_OPTION_SET" -eq 0 ] || fail "use --with-vale or --no-vale, not both"
      VALE_MODE="install"
      VALE_OPTION_SET=1
      ;;
    --no-vale)
      [ "$VALE_OPTION_SET" -eq 0 ] || fail "use --with-vale or --no-vale, not both"
      VALE_MODE="skip"
      VALE_OPTION_SET=1
      ;;
    --help|-h) usage; exit 0 ;;
    *) fail "unknown option '$1'" ;;
  esac
  shift
done

[ "$SELECT_ALL" -eq 0 ] || [ "${#SELECTED_SKILLS[@]}" -eq 0 ] || fail "use --all or --skill, not both"
[ "$VALE_MODE" != "install" ] || [ "$MODE" = "install" ] || fail "--with-vale cannot be used with --uninstall"
"$REPO_ROOT/scripts/validate-skills.sh" >/dev/null

ALL_SKILLS=()
while IFS=$'\t' read -r skill_name skill_description remainder; do
  case "$skill_name" in ''|'#'*) continue ;; esac
  ALL_SKILLS+=("$skill_name")
done < "$MANIFEST"

skill_exists() {
  local candidate="$1"
  local known
  for known in "${ALL_SKILLS[@]}"; do
    [ "$known" = "$candidate" ] && return 0
  done
  return 1
}

add_selected() {
  local candidate="$1"
  local existing
  skill_exists "$candidate" || fail "unknown skill '$candidate'"
  for existing in "${FINAL_SKILLS[@]:-}"; do
    [ "$existing" = "$candidate" ] && return 0
  done
  FINAL_SKILLS+=("$candidate")
}

FINAL_SKILLS=()
if [ "$SELECT_ALL" -eq 1 ]; then
  FINAL_SKILLS=("${ALL_SKILLS[@]}")
elif [ "${#SELECTED_SKILLS[@]}" -gt 0 ]; then
  for skill_name in "${SELECTED_SKILLS[@]}"; do add_selected "$skill_name"; done
else
  printf 'Available skills:\n'
  while IFS=$'\t' read -r skill_name skill_description remainder; do
    case "$skill_name" in ''|'#'*) continue ;; esac
    printf '  %-18s %s\n' "$skill_name" "$skill_description"
  done < "$MANIFEST"
  printf 'Select skill names separated by spaces, or type all. Empty input cancels: '
  selection=""
  if ( : </dev/tty ) 2>/dev/null; then
    IFS= read -r selection < /dev/tty || true
  else
    IFS= read -r selection || true
  fi
  [ -n "$selection" ] || { printf 'Cancelled. No changes made.\n'; exit 0; }
  if [ "$selection" = "all" ]; then
    FINAL_SKILLS=("${ALL_SKILLS[@]}")
  else
    selection="$(printf '%s' "$selection" | tr ',' ' ')"
    for skill_name in $selection; do add_selected "$skill_name"; done
  fi
fi

[ "${#FINAL_SKILLS[@]}" -gt 0 ] || { printf 'No skills selected. No changes made.\n'; exit 0; }

target_status() {
  local target="$1"
  local expected="$2"
  if [ -L "$target" ]; then
    [ "$(readlink "$target")" = "$expected" ] && printf 'managed' || printf 'wrong-link'
  elif [ -e "$target" ]; then
    printf 'occupied'
  else
    printf 'missing'
  fi
}

# Preflight every selected target before creating or removing anything.
for skill_name in "${FINAL_SKILLS[@]}"; do
  expected="$REPO_ROOT/skills/$skill_name"
  for runtime_dir in "$CODEX_DIR" "$CLAUDE_DIR"; do
    target="$runtime_dir/$skill_name"
    status="$(target_status "$target" "$expected")"
    if [ "$MODE" = "install" ]; then
      case "$status" in
        missing|managed) ;;
        occupied) fail "$target already exists and is not a symlink. No changes made." ;;
        wrong-link) fail "$target is a symlink to another source. No changes made." ;;
      esac
    else
      case "$status" in
        missing|managed) ;;
        occupied) fail "$target is not a repo-controlled symlink. No changes made." ;;
        wrong-link) fail "$target points somewhere else. No changes made." ;;
      esac
    fi
  done
done

if [ "$MODE" = "install" ]; then
  maybe_install_vale
  mkdir -p "$CODEX_DIR" "$CLAUDE_DIR"
  for skill_name in "${FINAL_SKILLS[@]}"; do
    expected="$REPO_ROOT/skills/$skill_name"
    for runtime_dir in "$CODEX_DIR" "$CLAUDE_DIR"; do
      target="$runtime_dir/$skill_name"
      [ "$(target_status "$target" "$expected")" = "managed" ] || ln -s "$expected" "$target"
      printf 'Installed %s -> %s\n' "$target" "$expected"
    done
  done
  printf 'Done. Start a new Codex or Claude Code session to ensure discovery.\n'
else
  for skill_name in "${FINAL_SKILLS[@]}"; do
    expected="$REPO_ROOT/skills/$skill_name"
    for runtime_dir in "$CODEX_DIR" "$CLAUDE_DIR"; do
      target="$runtime_dir/$skill_name"
      if [ "$(target_status "$target" "$expected")" = "managed" ]; then
        rm -- "$target"
        printf 'Uninstalled %s\n' "$target"
      else
        printf 'Already uninstalled: %s\n' "$target"
      fi
    done
  done
  printf 'Done. Start a new session. A host-provided skill will resume only if that host includes one with the same name.\n'
fi
