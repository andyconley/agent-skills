# Workbreakdown Skill Requirements

## Problem

Agents can produce plausible Jira breakdowns that misclassify work, confuse hierarchy with dependency, over-link issues, or write changes before a human has reviewed the intended graph. The existing SOP defines a consistent alternative, but it is not yet packaged as a portable skill for Codex and Claude Code.

## Outcome

Add a portable `workbreakdown` skill that uses a versioned YAML manifest as the reviewed contract between milestone planning and Jira. The same `SKILL.md` and references must drive Codex and Claude Code.

## Required modes

- Draft: propose the breakdown without Jira writes.
- Review: inspect a manifest and return the smallest corrections without Jira writes.
- Audit: inspect live Jira or a supplied export without Jira writes.
- Apply: reconcile Jira to a specific approved manifest only after direct user authorization.

Every Draft response must include the Epic outcome, child table, complete YAML manifest, dependency graph or edge list, graph checks, and material questions.

## Core rules

- Use `ER / Initiative -> Milestone Epic -> direct Spike, Task, and Story children`.
- Do not create subtasks for planned milestone work.
- Classify work by observable completion: bounded decision for Spike, concrete artifact for Task, integrated observable behavior for Story.
- Require every Task to contribute to a Story or explicit Epic exit condition and every Spike to inform a Task or Story.
- Interpret `A -> B` as A blocks B.
- Create only hard dependency links. Keep rank separate from dependency.
- Detect cycles, reversed links, duplicates, redundant transitive links, orphaned work, lost parallelism, and implicit cross-Epic dependencies.
- Preserve unknowns as unknowns. Do not invent Jira state, keys, estimates, evidence, permissions, acceptance criteria, or dependencies.

## Portability and safety

- Keep behavior in host-neutral Markdown. Codex metadata remains optional and thin.
- Enable automatic skill discovery on both hosts.
- Automatic selection never authorizes Jira writes.
- Do not bundle a Jira client, credentials, or a host-specific connector.
- If required Jira capabilities are unavailable, continue Draft or Review, request an export for Audit, and stop Apply.
- Apply must preflight live state, stop on material drift, limit changes to the approved scope, preserve unrelated work, and verify final state through readback.
