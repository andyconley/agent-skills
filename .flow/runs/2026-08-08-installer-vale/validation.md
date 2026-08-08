# Validation

```text
$ bash -n install.sh scripts/*.sh tests/*.sh
```

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
ok 12 - no-vale skips dependency handling
ok 13 - with-vale fails clearly when unsupported
ok 14 - with-vale installs through supported package manager
ok 15 - with-vale is rejected for uninstall
ok 16 - vale flags are mutually exclusive
1..16
```

```text
$ ./scripts/lint-prose.sh
0 errors, 0 warnings and 0 suggestions in 18 files.
```
