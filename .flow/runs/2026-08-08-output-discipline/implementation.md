# Implementation

## Files changed

- `skills/humanizer/SKILL.md`
- `skills/humanizer/VERSION`
- `skills/humanizer/agents/openai.yaml`
- `skills/doc-flow-review/SKILL.md`
- `skills/doc-flow-review/VERSION`
- `skills/doc-flow-review/assets/reviewer-block.md`
- `skills/doc-flow-review/agents/openai.yaml`
- `skills/manifest.tsv`
- `README.md`

## Files added

- `shared/agent-output-discipline.md`
- `examples/humanizer-agent-output.md`
- `examples/doc-flow-review-agent-output.md`
- `examples/agent-output-regression-prompts.md`

## Notes

- The shared contract lives at repo root, not under `skills/`, so existing validation rules remain intact.
- Each skill embeds fallback output rules directly, so it still works when a host only loads `SKILL.md`.
- Examples test bad and good agent output rather than only bad source prose.

