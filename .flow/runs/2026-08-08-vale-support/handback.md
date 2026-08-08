# Handback

## Summary

Added optional Vale support to `agent-skills`: config, custom rules, wrapper script, CI enforcement, and strict-mode integration.

## Proof

- `./scripts/validate-skills.sh`
- `./tests/install-test.sh`
- `./scripts/lint-prose.sh`
- `./scripts/lint-prose.sh examples/regression/`

## Remaining Risk

Vale catches stable surface tells only. It does not replace the skills' final gates, pattern classes, or manual regression review.

