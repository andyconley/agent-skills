# Handback

## Shipped

- `humanizer` 4.6.0:
  - mandatory normal-mode construction sweep
  - mirrored rhythm default-deny rule
  - STE-inspired discipline
  - self-authored draft bias rule
- `doc-flow-review` 1.5.0:
  - shared construction sweep on review output
  - stricter output discipline without expanding into prose rewriting
- Shared writing contracts:
  - priority order
  - final gates for STE discipline and mirrored rhythm
  - expanded pattern classes and suppression rules
- Vale:
  - `.txt` lint support
  - mirrored rhythm, aphoristic closer, signpost nominalization, weak STE, and long-sentence tripwires
- Regression/manual tests:
  - mirrored rhythm
  - STE-inspired discipline
  - protected technical parallelism

## Proof

- Local validation passed:
  - `bash -n install.sh scripts/*.sh tests/*.sh`
  - `./scripts/validate-skills.sh`
  - `./tests/install-test.sh`
  - `./scripts/lint-prose.sh`
  - `git diff --check`
- Targeted bad sample failed with the intended Vale rules.
- Protected parallelism fixture passed Vale.
- GitHub CI passed for pushed commit `589dd60`.
- Installer refreshed symlinks for Codex and Claude Code.

## Remaining Risk

Vale weak-word and long-sentence warnings may need tuning after real use. They are warnings, not errors.
