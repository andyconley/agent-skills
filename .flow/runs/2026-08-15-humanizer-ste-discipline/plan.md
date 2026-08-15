# Implementation Plan

## Change Surface

- `skills/humanizer/SKILL.md`
- `skills/doc-flow-review/SKILL.md`
- `skills/*/VERSION`
- `skills/manifest.tsv`
- `shared/agent-output-discipline.md`
- `shared/final-gates.md`
- `shared/pattern-classes.md`
- `tools/vale/.vale.ini`
- `tools/vale/styles/AgentVoice/*.yml`
- `examples/regression/*.md`
- `tests/manual/*.md`
- `README.md`

## Steps

1. Add shared writing contracts:
   - priority hierarchy
   - STE-inspired discipline
   - mandatory construction sweep
   - mirrored rhythm default-deny rule
   - protected-parallelism criteria
2. Update `humanizer`:
   - make construction sweep mandatory in normal mode
   - remove guidance that encourages decorative two-beat prose
   - add self-authored draft rule
   - make strict mode normal mode plus Vale
3. Update `doc-flow-review`:
   - inherit shared discipline for review output
   - keep structure-review boundary
4. Add Vale rules:
   - high-confidence mirrored rhythm
   - aphoristic closers
   - signpost nominalization
   - STE weak words and phrasal verbs
   - long sentences
5. Add regression fixtures:
   - must-flag examples from the failed sessions
   - protected examples that must survive
6. Update docs and versions.
7. Validate:
   - `./scripts/validate-skills.sh`
   - `./tests/install-test.sh`
   - `./scripts/lint-prose.sh`
   - targeted lint against new fixtures
8. Commit, push, sync `main`, install with `./install.sh --all`, and verify symlinks.
