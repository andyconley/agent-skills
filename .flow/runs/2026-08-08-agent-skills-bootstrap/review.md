# Review

## Scope reviewed

- Bootstrap clone/update behavior and origin/clean-checkout gates.
- Manifest and retirement declaration validation.
- Install and uninstall preflight across both runtime targets.
- Additive behavior, idempotency, and unrelated-skill preservation.
- Skill portability and host-specific metadata boundaries.

## Findings and disposition

1. Retired skills needed a declared holding state or CI would force their source removal. Added `skills/retired.tsv`; retired skills leave the install menu but keep their source path.
2. Reading `/dev/tty` in a non-interactive environment emitted an avoidable device error. The prompt now probes the controlling terminal and falls back to standard input cleanly.
3. No unresolved correctness, safety, or portability findings remain in the reviewed scope.
