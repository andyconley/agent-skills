# Requirements

## Problem

`humanizer` and `doc-flow-review` need stronger enforcement. The current skills contain good guidance, but agents can still interpret around it and produce AI-shaped output.

## Desired change

- Add optional strict mode to both skills.
- Add shared final gates.
- Add shared pattern classes.
- Add regression examples under `examples/regression/`.
- Add manual test prompts under `tests/manual/`.
- Keep runtime behavior agent-agnostic.
- Do not add Vale in this slice, but leave room for a future optional Vale pass.

## Versioning

- `humanizer`: `4.3.0` to `4.4.0`
- `doc-flow-review`: `1.2.0` to `1.3.0`

