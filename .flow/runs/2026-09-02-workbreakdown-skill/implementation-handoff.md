# Implementation Handoff

## Work ID

`2026-09-02-workbreakdown-skill`

## Starting state

- Repository: `/Users/andyconley/agent-skills`
- Branch: `main`
- The checkout was current at `5140bab` when planning began.
- `skills/workbreakdown/` contains an untracked initializer scaffold. Replace it; do not treat it as finished work.
- Requirements and acceptance criteria are approved in this run directory.

## Implementation order

1. Finish the portable skill entrypoint, version, and three canonical references.
2. Add manifest and repository documentation entries.
3. Add manual mode tests and explicit installer coverage.
4. Run package, version, prose, installer, and skill validators.
5. Install all skills into Codex and Claude Code through the repository installer.
6. Verify symlink targets, live versions, and fresh-session discovery inputs.
7. Review the full diff for host-specific assumptions, dropped SOP rules, ambiguous write authorization, and unsafe partial-failure behavior.

## Constraints

- Do not add Jira credentials, client code, or a required connector dependency.
- Do not let automatic invocation imply write authorization.
- Do not duplicate one rule across several references; assign each rule one canonical home.
- Preserve the meaning of the supplied SOP while removing meeting chatter and conversational provenance from runtime instructions.
- Do not claim transactional Jira behavior.
