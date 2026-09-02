# Implementation Record

## Planned slices

1. Portable skill package: entrypoint, version, canonical SOP, manifest contract, and Jira change protocol.
2. Repository integration: active manifest, public documentation, contributor guidance, and issue templates.
3. Proof and distribution: explicit installer tests, manual mode tests, static validation, mutation check, dual-runtime install, and discovery-input verification.

## Decisions

- Keep one Markdown behavior source for Codex and Claude Code.
- Keep `agents/openai.yaml` display-only and leave implicit invocation enabled.
- Do not add a Jira connector dependency. Apply mode maps semantic operations to capabilities supplied by the active host.
- Require a complete YAML manifest in every Draft response.
- Preserve the full supplied SOP across three references, with each rule assigned one canonical home.
