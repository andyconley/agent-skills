# Acceptance criteria: workbreakdown skill improvements

The fixture is private, held outside this repository. It consists of six epics, FX-E1 to FX-E6, under one Initiative, refreshed with link history. Cases are referenced by ID.

**Release gate for each slice:** a live-agent run against the fixture that passes every criterion listed for that slice, including its negative controls. Contract tests pass at the new VERSION. Public tests use synthetic fixtures.

## Slice A

- [ ] **AC-R0.1** An interactive Draft of FX-E1 asks the shaping and reviewer questions, then records each answer with its source in the output and the manifest.
- [ ] **AC-R0.2** A Draft of FX-E3 run after FX-E1 offers FX-E1's answers as the default and reports any divergence.
- [ ] **AC-R0.3** *Negative control:* a non-interactive Draft uses the portable defaults and says so. It records the reviewer gap in `unknowns` and contains no project vocabulary or names.
- [ ] **AC-R1.1** A Draft of each fixture epic, with Jira context, lists the existing children it read. It maps each proposed item to an existing card or marks it new.
- [ ] **AC-R1.2** FX-STALE-1 conflicts are reported with both sources and the winning, most recent decision. No proposed item depends on the dropped design.
- [ ] **AC-R1.3** The design page is flagged as possibly stale for FX-STALE-2 and FX-STALE-3.
- [ ] **AC-R1.4** *Negative control:* a Draft with no Jira context says so and marks design claims unverified.
- [ ] **AC-R2.1** Every Spike names its question and where the skill looked for precedent.
- [ ] **AC-R2.2** FX-BOUNDS stays a Spike. FX-PATTERN items are proposed as Tasks with the location of the pattern they rely on. *Negative control:* without repository access, no Spike is converted to a Task on an unverified precedent.
- [ ] **AC-R2.3** Each user flow in FX-E1 has one vertical-slice Spike. No front-end-only Spike like FX-FE-SPLIT appears unless the UI is the stated question.
- [ ] **AC-R2.4** The Draft declares its Task granularity and its source. Review of the team's existing children does not flag their layer-split Tasks.
- [ ] **AC-R2.5** Review flags the FX-COMP-STORY Stories as component Stories.
- [ ] **AC-R2.6** Undesigned work appears as marked placeholders, each linked to its defining Spike. They render without an unresolved-placeholder rejection.
- [ ] **AC-R2.7** Every Spike has a reviewer slot. It is filled from a source or an R0 answer; otherwise the gap is recorded in `unknowns` and nobody is invented.
- [ ] **AC-R2.8** The SOP no longer says "prefer several short Spikes" or "one to two days per Spike or Task", and it still states the intent those lines had: narrow questions and forecastable work.
- [ ] **AC-R5** On the fixture, every exit condition and every in-scope user-facing surface has an owning card. The existing graph, Apply-refusal and Story-evidence tests pass unchanged.
- [ ] **AC-A-regression** Across the six epics, none of the original failure categories recurs unflagged. The categories are stale design, misclassified Spike, over-split flow, component Story, and invented or missing undesigned work.

## Slice B

- [ ] **AC-R3.1** A single-Epic Draft of FX-E3 runs the consolidation check and announces it. *Negative control:* with the opt-out set, it does not run and the output says so.
- [ ] **AC-R3.2** For each FX-COLLISIONS case, one owner is proposed with a rationale and marked as proposed until the lead confirms it.
- [ ] **AC-R3.3** With order taken from rank, FX-EXCEPTIONS appear as recorded exceptions, and any unrecorded later-to-earlier edge is a defect. *Negative control:* with no rank, order is reported as "unknown".
- [ ] **AC-R3.4** FX-COPY-ACCEPT is reported as a missing forward edge or as misplaced acceptance.
- [ ] **AC-R4.1** FX-REV-LINKS are reported as contradicting the ticket's own text.
- [ ] **AC-R4.2** FX-DONE-LINK is reported.
- [ ] **AC-R4.3** FX-TEXT-BLOCKERS are reported.
- [ ] **AC-R4.4** FX-STATUS is reported using status category, with no project status names in the core.
- [ ] **AC-R4.5** FX-REV-LINKS are classified `mechanical` and FX-SCOPE-LINKS `scope-disagreement`, each citing the author and date from the link history. *Negative control:* with history removed, both are classified `unknown`.
- [ ] **AC-B-precision** *Negative control:* FX-FORWARD-OK links are not reported.

## Amendments

The approved criteria above are left as written, and these dated maintainer rulings qualify how they are proven.

- **2026-09-25, AC-R4.1.** Only the FX-REV-LINKS edges with quotable contradicting text are required as `contradicts-text` findings. The other FX-REV-LINKS edges are optional, and all of them stay in the AC-R4.5 classification key.
- **2026-09-25, AC-R3.2.** One FX-COLLISIONS pair with no live card was dropped. Each remaining pair is checked on the Draft of an Epic in that pair, and claims cover only pairs that include the scoped Epic.
- **2026-09-25, AC-R4.4.** Ready statuses come only from the invocation request. Without them, status checks use status category alone.
