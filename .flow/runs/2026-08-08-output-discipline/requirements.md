# Requirements

## Problem

`humanizer` and `doc-flow-review` have the right intent, but agents can still produce long, polished, AI-sounding output while technically following them.

## Desired change

- Tighten both skills so the default output is concise, concrete, and human.
- Add shared output discipline that is agent-agnostic across Codex, Claude Code, and other hosts.
- Add examples and regression prompts that show the failure mode and target behavior.
- Keep the skills portable in `andyconley/agent-skills`.
- Create and merge a PR into the GitHub repo.

## Versioning

- `humanizer`: `4.0.0` to `4.1.0`
- `doc-flow-review`: `1.0.0` to `1.1.0`

