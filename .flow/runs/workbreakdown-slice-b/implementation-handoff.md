# Implementation handoff: workbreakdown Slice B

## Where

- **Skill source:** the `agent-skills` worktree on branch `claude/workbreakdown-slice-b`. Commit only there. Pushing waits for the maintainer.
- **Private release check:** a private workspace, outside this repository. It holds the fetch script, `cases.yaml`, the checker, the fixture snapshots and the answer key. None of that content enters this repository.

## Read first

1. `plan.md`: the steps, planning decisions 1 to 9, the interpretations and the stop points.
2. `validation-plan.md`: the gates, the named mutants and the release-check design.
3. `research/plan-architect.md`: file, section and line detail, draft pin text and error fragments. Apply planning decisions 6 to 9 over it.
4. `solution.md`: the design and its rejected alternatives.

## Hard rules

- **This repository is public.** Grep every diff before committing for fixture Jira keys, people's names, private repository names and absolute home paths.
- **Never write to Jira.** The fixture refresh is GET-only.
- **The agent under test** never gets Jira credentials, Bash, network or MCP, and runs on Opus.
- **No estimates.**
- **Commit before any mutation check,** and judge each mutant by exit code.
- **Don't edit a running gate's inputs.**
- **Branches.** Commit only on `claude/*` branches, and never try to get around the commit gate hook.
- **Don't permanently delete files.** Move them to the Trash.
- **Every new utility gets a README.** The release-check README must be updated in the same change as any functional change to it.

## Order

1. Step 0, `gate-b`, and the case-presence check.
2. C1.
3. C2.
4. C3.
5. C4.
6. C5a: stop for ratification.
7. C5.
8. R.

Run the per-step gate after every step.

## Run protocol

```bash
flow run transition workbreakdown-slice-b start-implementation
flow run transition workbreakdown-slice-b mark-handback-ready \
  --artifact implementation_evidence=.flow/runs/workbreakdown-slice-b/validation-results.md \
  --artifact handback=.flow/runs/workbreakdown-slice-b/HANDOFF.md
```
