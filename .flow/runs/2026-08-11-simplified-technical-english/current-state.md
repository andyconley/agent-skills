# Current State

## Versions at start

- `humanizer` 4.5.0
- `doc-flow-review` 1.4.0

## Repository constraints that shape the change

### Version consistency is enforced

`scripts/validate-skills.sh` requires each skill version in three places:

1. `skills/<slug>/VERSION`, matching `MAJOR.MINOR.PATCH`
2. the frontmatter description, as `Version X.Y.Z` exactly once
3. the body, as `**Version: X.Y.Z.**` exactly once

It also requires the frontmatter `name` to match the directory, and the manifest to match the directory listing exactly.

### CI lints prose and fails on errors

`.github/workflows/ci.yml` runs Vale over `README.md`, `skills`, `shared`, and `tests/manual` with `fail_on_error: true`. Only `level: error` breaks the build.

New Vale rules enter at `warning` and `suggestion`. An `error`-level rule would lint the skill files themselves into a red build.

`.flow/` is not linted, so run artifacts are unconstrained.

### Vale picks up new styles without configuration

`tools/vale/.vale.ini` sets `BasedOnStyles = AgentVoice`. Any new rule file in `tools/vale/styles/AgentVoice/` is active. No `.vale.ini` change is needed.

Vale 3.17.1 is installed locally, so rules can be verified before commit.

## Pre-existing phrasal verbs in linted paths

Three matches, one of which is a false positive:

| Location | Text | Status |
| --- | --- | --- |
| `skills/doc-flow-review/SKILL.md:24` | `turn one problem into...` | False positive. `turn on` is a substring of `turn one`. |
| `skills/humanizer/SKILL.md:128` | `Fill out the template.` | Genuine. Inside a nominalized-state example. |
| `shared/agent-output-discipline.md:29` | `would put in a working doc` | Genuine. |

The false positive is the important finding: substitution tokens need word-boundary anchoring, or the rule flags correct prose.

## Existing patterns the change must follow

- **Regression fixtures** — `examples/regression/*.md`, five files, each with `Bad Source`, `Why It Fails`, `Expected Shape`, `Pass Checks`.
- **Manual tests** — `tests/manual/<skill>.md`, each case a prompt plus `Passes if` and `Fails if` lists.
- **Vale styles** — `extends: existence` with a token list, a `message` carrying `%s`, `level`, and `ignorecase: true`.
- **Pattern classes** — `shared/pattern-classes.md` groups into Shared, Humanizer, and Doc Flow Review classes. Each class has Tell lines and a Fix line.
- **Shared doctrine is referenced, never duplicated.** Both skills point at `shared/` files rather than restating them.

## Where the change lands

`shared/agent-output-discipline.md` governs the agent's own replies and is loaded by both skills. Adding vocabulary rules there means doc-flow-review's findings follow them too. That is consistent with the decision to scope doc-flow-review's *checks* to terminology only; the shared contract has always governed how it writes.

The file already cuts decorative certainty under "Cut by default". "Numbers, not adjectives" extends that bullet rather than competing with it.
