# Documentation

This repo ships portable writing skills for Codex, Claude Code, and other LLM runtimes.

Start with the [main README](../README.md) for install, update, uninstall, usage, and development commands.

## Skill Docs

- [`humanizer`](../skills/humanizer/SKILL.md): rewrites prose into a direct engineering-leader voice while preserving facts, caveats, and protected technical material.
- [`doc-flow-review`](../skills/doc-flow-review/SKILL.md): reviews document structure, information order, progressive disclosure, argument support, and depth.

When a document needs both skills, run `doc-flow-review` first. Apply the structural decisions, then run `humanizer` on the prose.

## Shared Writing Rules

- [Agent output discipline](../shared/agent-output-discipline.md): default response contract and construction sweep.
- [Final gates](../shared/final-gates.md): response checks for utility, scope, evidence, and prose quality.
- [Pattern classes](../shared/pattern-classes.md): known failure patterns such as mirrored rhythm, stance sentences, polished labels, and author-state narration.

## Examples and Tests

- [Agent output regression prompts](../examples/agent-output-regression-prompts.md): manual prompts for known failure modes.
- [Regression fixtures](../examples/regression/): bad source/output, failure reasons, expected shapes, and pass checks.
- [Manual tests](../tests/manual/): live-agent checks for skill behavior.
- [STE before/after](../examples/ste-before-after.md): worked example for the STE-inspired rules.

## Tooling

- [Vale support](../tools/vale/README.md): optional mechanical prose linting.
- [`scripts/validate-skills.sh`](../scripts/validate-skills.sh): manifest, version, and skill metadata validation.
- [`tests/install-test.sh`](../tests/install-test.sh): installer regression tests.

## Contributing

Use [CONTRIBUTING.md](../CONTRIBUTING.md) for local setup, validation, pull requests, and the skill lifecycle.
