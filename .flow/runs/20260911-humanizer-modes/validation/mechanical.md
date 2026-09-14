# Mechanical validation

2026-09-14T18:06:32.242386+00:00

- SKILL.md: SHA-256 `61c6d7577d99f8debc557b1abbbb066369e5462df14c45164ec62204f9c7f293`
- references/policy.md: SHA-256 `53a8a9b787777f4ce0d011fdb1dfd4075c943947801760f97abd8aa3c3565cf2`

## `bash -n install.sh scripts/*.sh tests/*.sh tests/workbreakdown/*.sh`

Exit: 0

```text

```

## `./scripts/validate-skills.sh`

Exit: 0

```text
Validated 3 skills.
```

## `python3 tests/humanizer-fixture-test.py`

Exit: 0

```text
Validated 27 writing fixtures across six groups and compatibility checks.
Missing-reference and disconnected-reference faults were rejected for the policy file.
Combined policy includes the ten-class personal diagnostic inventory.
```

## `./tests/install-test.sh`

Exit: 0

```text
ok 1 - manifest validates
ok 2 - empty interactive selection cancels without changes
ok 3 - one skill installs to both runtimes
ok 4 - humanizer references are readable through both installed skill links
ok 5 - workbreakdown installs and uninstalls on both runtimes
ok 6 - repeat install is idempotent
ok 7 - all installs every declared skill
ok 8 - unrelated targets are preserved
ok 9 - selected uninstall is narrow
ok 10 - repeat uninstall is idempotent
ok 11 - preflight prevents partial install on directory conflict
ok 12 - wrong symlink stops installation
ok 13 - uninstall preflight prevents partial removal
ok 14 - no-vale skips dependency handling
ok 15 - with-vale fails clearly when unsupported
ok 16 - with-vale installs through supported package manager
ok 17 - with-vale is rejected for uninstall
ok 18 - vale flags are mutually exclusive
1..18
```

## `./tests/lint-prose-test.sh`

Exit: 0

```text
lint-prose tests passed
```

## `./tests/workbreakdown-contract-test.sh`

Exit: 0

```text
workbreakdown template contract tests passed
Workbreakdown contract checks passed.
```

## `LC_ALL=C LANG=C ./tests/workbreakdown-contract-test.sh`

Exit: 0

```text
workbreakdown template contract tests passed
Workbreakdown contract checks passed.
```

## `./scripts/lint-prose.sh --profile repository`

Exit: 0

```text
✔ 0 errors, 0 warnings and 0 suggestions in 50 files.
```

## `./scripts/lint-prose.sh --help`

Exit: 0

```text
Usage: scripts/lint-prose.sh [--profile repository|engineering|personal] [--] [file-or-directory ...]

Profiles:
  repository   Lint the repository's governing prose targets (default).
  engineering  Lint explicit engineering-writing targets with blocking rules.
  personal     Lint explicit personal-writing targets with advisory rules.

Engineering and personal profiles require at least one explicit target. Use --
before targets that begin with a dash.

A bare target without --profile uses the engineering profile for existing
strict skill callers. Prefer an explicit profile in new callers.
```

## `./scripts/manage-skills.sh --help`

Exit: 0

```text
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
```

## `python3 /Users/andyconley/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/humanizer`

Exit: 0

```text
Skill is valid!
```

## `git diff --check`

Exit: 0

```text

```
