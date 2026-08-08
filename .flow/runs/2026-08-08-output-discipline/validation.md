# Validation

## Automated

```text
$ ./scripts/validate-skills.sh
Validated 2 skills.
```

```text
$ ./tests/install-test.sh
ok 1 - manifest validates
ok 2 - empty interactive selection cancels without changes
ok 3 - one skill installs to both runtimes
ok 4 - repeat install is idempotent
ok 5 - all installs every declared skill
ok 6 - unrelated targets are preserved
ok 7 - selected uninstall is narrow
ok 8 - repeat uninstall is idempotent
ok 9 - preflight prevents partial install on directory conflict
ok 10 - wrong symlink stops installation
ok 11 - uninstall preflight prevents partial removal
1..11
```

## Manual

- Reviewed diff for version drift.
- Searched skill, shared, examples, and README content for host-specific assumptions.
- Confirmed direct skill behavior is Markdown-only and agent-agnostic.

