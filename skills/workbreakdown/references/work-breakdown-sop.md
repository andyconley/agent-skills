# Epic Work Breakdown SOP

Use this policy for work below an ER or Initiative.

## Work-item roles

| Type | Purpose | Done when |
| --- | --- | --- |
| Epic | Deliver a milestone capability | The milestone behavior is demonstrated and its Stories pass |
| Spike | Answer one research, design, or feasibility question | The decision, evidence, constraints, and downstream effect are recorded |
| Task | Produce a specific implementation or operational artifact | The named code, configuration, infrastructure, test asset, or deployment exists and is verified |
| Story | Package integrated, observable behavior | Its Gherkin scenarios and integration tests pass against the delivered system |

Create a direct Epic child when work needs an owner, estimate, status, dependency, or completion evidence. Do not use subtasks for planned milestone work.

## Breakdown procedure

1. **Define the Epic outcome.** State the capability that becomes available. Target about one month or two sprints. Treat two months as the upper limit before considering another milestone Epic.
2. **Define verifiable Stories.** Work backward from demonstrations that prove the Epic. A Story can be a delivery checkpoint, but it must package real behavior, validation, and integration evidence.
3. **Identify implementation Tasks.** Add the code, infrastructure, configuration, packaging, and operational work needed to make each Story pass. Give every Task a clear completion state.
4. **Isolate uncertainty as Spikes.** Create one Spike for each unanswered decision. Keep the question narrow. Prefer several short Spikes over one open-ended research ticket.
5. **Connect the work.** Use `Spike -> Task -> Story` as the normal flow. One Spike can block several Tasks. Several Tasks can block one Story. A Spike can block a Story directly when no implementation Task is needed.
6. **Rank the children.** Rank items in reading and likely execution order: Spikes, Tasks, Stories. Rank communicates priority and presentation order, not dependency.
7. **Review the graph.** Make every edge point from prerequisite to consumer and eventually reach a verifiable Story or explicit Epic exit condition.

## Dependency rules

Create a `Blocks` link only when the consumer cannot finish safely without the blocker. Do not use `Blocks` to:

- arrange cards visually
- show that two items are related
- repeat a parent-child relationship
- link every upstream item to every downstream item
- express preferred execution order

Remove transitive links when they add no information. If `A -> B -> C`, omit `A -> C` unless C directly consumes an artifact from A.

Every graph must satisfy these checks:

- No cycles.
- No Story blocks implementation required by that Story.
- Every Task contributes to a Story or the Epic exit condition.
- Every Spike informs a Task or Story.
- Parallel work remains parallel.
- Cross-Epic dependencies are explicit.
- Completed work does not depend on unfinished downstream work.

## Sizing and refinement

- Create known work early so the milestone can be forecast. Mark estimates as provisional while blocking Spikes remain open.
- Aim for one to two days of focused work per Spike or Task when practical.
- Treat five points as a review trigger. Check whether the item contains multiple outcomes or decisions.
- Do not split work only to reduce an estimate. Each resulting item needs its own completion state.
- Estimate enough work to forecast the milestone.
- Revalidate estimates before sprint commitment.
- Update downstream Tasks and Stories when a Spike changes the expected implementation.
- Review the graph during weekly refinement and after a material design decision.
- Record the reason for a material estimate change in the ticket.

Changing an estimate after research is normal.

## Story acceptance

Each Story should include:

- observable behavior
- Gherkin scenarios for the main path
- failure and authorization scenarios where applicable
- version or compatibility behavior where applicable
- the integration test that proves each scenario
- packaging or deployment evidence
- the environment where the behavior was verified

Integration tests can be written before implementation and remain failing until the Tasks are complete.

## Spike completion

When a Spike finishes, read its decision and evidence. Identify every downstream Task and Story it affects. Propose description, acceptance, estimate, dependency, and rank changes. Do not change Jira until that delta is reviewed.

## Example flow

```text
[Spike] Inventory available state
    |
    v
[Spike] Define state model and freshness rules
    |
    v
[Spike] Design source projection
    |---> [Task] Implement source adapters
    |         |---> [Task] Implement failure routing
    |         |          `---> [Story] Prove real state reads
    |         `---> [Task] Implement persistence
    |                    `---> [Task] Add telemetry
    `---> [Spike] Design persistence

[Story] Prove real state reads + [Task] Add telemetry
    `---> [Task] Qualify supported versions
              `---> [Story] Complete and operate state reads
```

The drawing is illustrative. Validate every edge against the hard-dependency rule rather than copying the shape.
