# Documentation

This repo ships portable writing skills for Codex, Claude Code, and other LLM runtimes.

Start with the [main README](../README.md) for install, update, uninstall, usage, and development commands. Use this page when you want to understand the strategy behind the repo and how the lower-level files fit together.

## Intent

The skills in this repo are meant to make agents better at writing without making them dependent on one host application.

The first goal is reliable behavior. A skill should define the task, protected material, failure modes, and self-checks. The second goal is portability. The skill should work when a host reads Markdown instructions, even if that host ignores Codex metadata, cannot run scripts, or has no access to Vale.

The repo treats writing quality as behavior, not taste. The skills name known failure modes, provide examples, and use regression prompts so a maintainer can test whether a change improved the agent or only changed the wording.

## Strategy

The repo separates the writing problem into layers.

`doc-flow-review` handles document shape. It asks whether the reader gets the right context in the right order, whether claims are earned, and whether deep detail appears where it helps.

`humanizer` handles prose after the structure is sound. It removes agent-shaped sentence architecture, corporate filler, stance sentences, author-state narration, and decorative rhythm while preserving facts, caveats, commands, identifiers, and protected requirements.

The shared files make both skills behave like parts of one system:

- `shared/agent-output-discipline.md` defines the default response contract and construction sweep.
- `shared/final-gates.md` defines the checks each response must pass before it is returned.
- `shared/pattern-classes.md` names failure families so agents can catch new variants instead of matching only old phrases.

The examples and manual tests keep the strategy honest. They show the behavior that should pass, the behavior that should fail, and the reason a failure matters.

## Theory

The repo assumes that most poor agent writing comes from structure and sentence architecture.

Vocabulary cleanup helps only after the document has the right shape. Replacing corporate words with plain words still fails if the answer opens with method narration, repeats the same sentence shape, preserves polished template headings, or makes the author the subject of every claim.

That is why the normal path is:

1. Use `doc-flow-review` when the document may have a structure problem.
2. Apply the structural decisions.
3. Use `humanizer` to rewrite the prose.
4. Use final gates, pattern classes, examples, and optional Vale checks to catch regressions.

The STE-inspired rules apply pressure in the same direction. They favor short sentences, active voice, one term for one thing, plain verbs, numbers when numbers are known, and no deleted caveats. These skills use that discipline without claiming ASD-STE100 compliance.

## Skill Docs

- [`humanizer`](../skills/humanizer/SKILL.md): rewrites prose into a direct engineering-leader voice while preserving facts, caveats, and protected technical material.
- [`doc-flow-review`](../skills/doc-flow-review/SKILL.md): reviews document structure, information order, progressive disclosure, argument support, and depth.

When a document needs both skills, run `doc-flow-review` first. Apply the structural decisions, then run `humanizer` on the prose.

## Runtime Model

The source of truth is the skill directory, not a generated runtime copy.

Each skill directory contains:

- `SKILL.md`: the behavior contract loaded by the agent.
- `VERSION`: the semantic version reported by the skill.
- `agents/openai.yaml`: optional Codex metadata.
- `assets/`: supporting text used by the skill when needed.

The installer links selected skill directories into the default Codex and Claude Code skill locations. It does not copy the files or delete unrelated skills. Other LLM hosts can use the same `SKILL.md` files directly.

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

## Maintenance Model

Changes should improve behavior that can be observed. Add or update examples when a change targets a known failure mode. Add regression prompts when the failure is easier to see in a live agent than in static validation.

Use Vale for stable surface tells, not for judgment. A Vale rule is useful when the pattern is repeatable and false positives are manageable. Pattern classes remain the higher-level check because new agent prose failures rarely arrive with the exact same phrase.

Retired skills stay declared in `skills/retired.tsv` and keep their source directories. That lets existing symlinks keep working while new installs stop listing the retired skill.

## Contributing

Use [CONTRIBUTING.md](../CONTRIBUTING.md) for local setup, validation, pull requests, and the skill lifecycle.
