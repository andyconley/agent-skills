# Definition: workbreakdown skill improvements from a real-Initiative tabletop

- Work item: workbreakdown-skill-improvements
- Status: Approved 2026-09-24 by the maintainer
- Provenance: this was defined in a private run, which holds the evidence, the research note, the role reviews and the fixture, all maintained outside this repository. This public copy is sanitized. Project names, ticket keys, people and meeting content were removed, and fixture cases are referred to by ID only (`FX-*`). The requirements are unchanged from the approved private version.

## Problem

We ran workbreakdown 1.4.0 on six real milestone epics under one Initiative, working blind to the existing children. The breakdowns passed the skill's own graph checks, but a lead had to rebuild them by hand. They had four kinds of problem:

- They built on a design the team had dropped two weeks earlier, because design pages were stale and only Jira amendments recorded the change.
- They misclassified Spikes in both directions. Pattern work became Spikes, and a genuine unknown became Tasks on the strength of a false precedent claim.
- They over-split flows by layer and made Stories out of components.
- Each epic decided ownership locally, so decisions that span epics collided.

Separately, Audit on live Jira checks graph structure only. It would not catch links whose direction contradicts the ticket's own text, blockers written only in descriptions, or statuses that contradict open blockers.

Two SOP lines drive the over-splitting: "prefer several short Spikes" and "one to two days per Spike or Task".

**Who:** the maintainer, and the leads and engineers who use the skill one Epic at a time.

**Why:** durable quality on future runs. The tabletop is the regression fixture.

## Desired outcome

With Jira context available, a Draft proposes work that matches the Epic's current decisions, and states its judgment calls and sources. Audit finds link and status defects and says whether each looks mechanical or like a scope disagreement.

## Requirements, in two gated slices

### Slice A (planned first)

**R0. Invocation questions, recorded answers, reused defaults.** No project config file.
- R0.1 At invocation, Draft asks the shaping questions the sources don't answer. At minimum: one vertical-slice Spike per user flow, or split by layer; one implementation Task per flow, or finer. It asks for reviewers when no source names them.
- R0.2 Each answer is recorded in the Draft output and the manifest, with its source (`asked`, `reused` or `default`).
- R0.3 When sibling Epics already have recorded answers, Draft offers them as the default and reports any divergence.
- R0.4 In a non-interactive run, Draft uses the portable defaults and says so. Reviewers become an `unknowns` gap.
- R0.5 No setup is required.

**R1. Source authority and drift.**
- R1.1 Draft first reads the Epic's existing children: descriptions, amendments, statuses, links and link history. It reconciles against that work.
- R1.2 The most recent dated decision wins, and a Jira amendment counts as a decision. The lead can supply a different source-type order as an R0 answer. Each material conflict is reported with both sources and the winner. A conflict is material when it would change a classification, an owner or an edge.
- R1.3 A design source contradicted by a later-dated decision is flagged as possibly stale. Draft never builds silently on a flagged claim.
- R1.4 With no Jira context, Draft says so and marks design claims taken from sources as unverified.

**R2. Classification.**
- R2.1 A Spike names its open question and says why no precedent answers it, citing where the skill looked.
- R2.2 A Task that relies on a pattern cites where that pattern lives. An unverified precedent, including one unverified because there was no repository access, cannot on its own turn a Spike into a Task.
- R2.3 The Draft default is a vertical slice: one Spike per user-facing flow across all layers. A single layer becomes its own Spike only when that layer is the open question.
- R2.4 Draft declares its Task granularity and its source. R2.3 and R2.4 are Draft defaults only. Review and Audit never flag a team's different choice.
- R2.5 Draft and Review enforce that a Story is a demoable user, partner or system flow. A component Story is a Review finding.
- R2.6 Placeholder Tasks are first-class. Each has a one-line purpose, is linked to its defining Spike, and is marked not implementation-ready.
- R2.7 Every Spike has a reviewer slot. Reviewers are named people from a source or an R0 answer. Nobody is invented.
- R2.8 Rewrite the two over-splitting SOP lines so they keep their intent: narrow questions and forecastable work.

**R5. Preserve strengths.**
- R5.1 Every exit condition has an owning card.
- R5.2 Every in-scope user-facing surface has an owning card.
- R5.3 Blocks semantics, graph checks, fail-closed Apply and the Story evidence obligations are unchanged.

### Slice B (solutioned later)

**R3. Cross-epic consistency.** The skill runs a consolidation check automatically whenever sibling Epics exist, including for a single-Epic Draft, and it can be opted out of explicitly.
- It proposes one owner for each shared decision, and the lead confirms.
- Milestone order comes from the Initiative's rank or a declared list. Otherwise order is reported as unknown.
- A later-to-earlier edge is a defect unless it is recorded as an exception.
- Acceptance sits in the same Epic as the work that proves it, or is joined to it by a forward edge.

**R4. Semantic Audit checks.**
- A link whose direction contradicts the ticket's text.
- A link into Done or Rejected work.
- A later-to-earlier edge.
- Blockers stated only in text.
- A status that contradicts open blockers. Core uses Jira status categories.

Each link finding is classified `mechanical`, `scope-disagreement` or `unknown` from the link history, and cites the author and date. There is no manifest change; this is a new Audit output item.

## Non-goals

- An estimate or ticket-count mode.
- Changes to Blocks semantics, Apply, or the Story evidence rules.
- Auto-fixing Jira.
- Project-specific names or statuses in the skill core.
- Flagging a team's own task granularity.

## Constraints

- The skill stays public and portable.
- Contract changes need a VERSION bump, updated template hashes and registry tests, and a migration note. The bump happens once, when Slice A is complete.
- Release is gated on a live-agent run of the private fixture with negative controls. The fixture and its script are never committed here, and public tests use synthetic fixtures only.
- Jira text is untrusted data.

## Assumptions

- The Jira changelog exposes link author and date. Confirmed on the fixture instance.
- Live Jira read access is normal for leads. Repository access is not guaranteed, and R2.2 degrades to `unverified` without it.

## Next lane

Slice A: `flow-solution`, which is complete, then `flow-plan`, chunk by chunk.
