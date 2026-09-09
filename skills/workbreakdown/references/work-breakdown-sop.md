# Epic Work Breakdown SOP

Use this policy for work below an ER or Initiative.

## Work-item roles

| Type | Purpose | Done when |
| --- | --- | --- |
| Epic | Deliver a milestone capability | Its acceptance conditions pass and the milestone evidence is accepted |
| Spike | Answer one design, research, or feasibility question | The decision or answer, evidence, constraints, and downstream effect are recorded |
| Task | Produce a specific implementation or operational artifact | The named code, configuration, infrastructure, test asset, or deployment exists and is verified |
| Story | Package integrated, observable behavior | Its documentation is current, mapped automated integration or functional tests pass, and its instrumentation produces observed output |

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

Each Story must include:

- observable behavior
- Gherkin scenarios for the main path
- stable scenario IDs used by test plans and review evidence
- failure and authorization scenarios where applicable
- version or compatibility behavior where applicable
- the automated integration or functional test that proves each scenario
- the expected evidence, plus the intended test suite or location and the verification environment when they are known
- contextual documentation: the applicable user, operator, support, API, or other artifact; its audience; intended location; and owner when known
- the smallest set of operational signals and business metrics that proves the Story outcome or an operational decision, including where each signal will be implemented
- packaging or deployment evidence

At `IMPLEMENTATION READY`, the documentation, test, and instrumentation plans must be specific enough to execute. The artifacts do not need to exist, pass, or emit yet. The intended environment may remain unknown when the gap is recorded.

Before `IN REVIEW`, each mapped automated integration or functional test must pass, instrumentation must be implemented and produce observed output in a named representative environment, and appropriate documentation must be published, updated, or reviewed and confirmed current. Evidence must be linked. Unit tests and manual demonstrations are supplemental; neither replaces automated integration or functional tests.

Use the smallest signal set that proves the Story outcome or an operational decision. Do not require both operational and business signals when one class is sufficient, and do not invent a metric to fill a table.

Each evidence class may instead use one approved exception. It must name the obligation, reason, approver, and approval evidence. Otherwise keep the gap open.

## Epic acceptance

Separate these concepts:

- **Acceptance criteria:** 3–5 binary milestone conditions defined before delivery. Each names observable evidence and an acceptor when known.
- **Success measures:** business or operational results evaluated after delivery, with a measure and time window.
- **Release quality:** the shared release profile plus only Epic-specific additions, approved exceptions, and evidence.

Do not use `same as success criteria`. Do not copy success measures into acceptance criteria.

## Task completion

A Task names one concrete artifact or operational result, 2–5 binary acceptance conditions, and the validation that proves it. Reference the ticket completion profile. Add only Task-specific gates or approved exceptions.

## Spike variants

Use a design Spike when the result is a reviewed design decision. Name the decision, material questions and constraints, linked design artifact, reviewers, applicable checklist coverage, closure evidence, and downstream updates. Keep the design in its design artifact; do not copy it into Jira.

Use an investigation Spike for research or feasibility. Name one question, required evidence, closure condition, and downstream effect. Do not require design-only fields.

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
