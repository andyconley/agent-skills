# Plan

Branch: `add-ste-vocabulary-discipline`

## Slice 1 — shared doctrine

`shared/pattern-classes.md`

- Add a `Term Drift` class under Shared Classes. Both skills reference it; neither duplicates it.

`shared/agent-output-discipline.md`

- Add a `Word choice` section: plain verbs instead of phrasal verbs, one term per thing, numbers instead of adjectives.
- Extend the existing decorative-certainty bullet rather than adding a competing rule.
- Fix `would put in a working doc` to `would use in a working doc`.

## Slice 2 — humanizer 4.5.0 to 4.6.0

`skills/humanizer/SKILL.md`

- Reference branch gains the STE rules: one term per thing, plain verbs, no idioms, one instruction per step, numbers instead of adjectives.
- Mixed branch gains the escalation rule: STE applies to the whole document when any section is reference, checklist, or procedure.
- "Moves that add human texture" gains a scope line pointing at the branch rules.
- Measurable checks gain two entries: distinct names per concept, and phrasal-verb count.
- New short section recording the STE lineage and the dictionary limit.
- Fix `Fill out the template.` to `Complete the template.`
- Version string updated in the description and body.

`skills/humanizer/VERSION` to `4.6.0`.

## Slice 3 — doc-flow-review 1.4.0 to 1.5.0

`skills/doc-flow-review/SKILL.md`

- Pass 2 gains one terminology-consistency question, tagged `[disclosure]`.
- Version string updated in the description and body.

`skills/doc-flow-review/VERSION` to `1.5.0`.

## Slice 4 — Vale rules

`tools/vale/styles/AgentVoice/PlainVerbs.yml`

- `extends: substitution`, `level: warning`.
- Tokens anchored so `turn on` does not match `turn one`.

`tools/vale/styles/AgentVoice/TermDrift.yml`

- `extends: substitution`, `level: suggestion`.
- Generic writing pairs. Header comment states the list is a starter set meant to be replaced.

Verify both against the repo with local Vale before committing.

## Slice 5 — documentation surfaces

- `tools/vale/README.md` — describe both rules and the starter-list convention. Add `suggestion` to the rule-levels list.
- `README.md` — record what the skills borrow from STE and what they do not.
- `skills/*/agents/openai.yaml` — update both `short_description` strings.

## Slice 6 — proof

- `examples/regression/humanizer-term-drift.md`
- `examples/regression/humanizer-phrasal-verbs.md`
- `tests/manual/humanizer.md` — one case covering both rules.
- `examples/ste-before-after.md` — a live before/after on a reference document.

## Validation

1. `./scripts/validate-skills.sh`
2. `bash -n install.sh scripts/*.sh tests/*.sh`
3. `./tests/install-test.sh`
4. `./scripts/lint-prose.sh` — no new errors; confirm the two genuine phrasal hits are gone and `turn one problem` is not flagged
5. Fresh-session smoke: humanizer reports 4.6.0

## Rollout

Local commits on the branch, one per slice, Conventional Commits. No push until asked.
