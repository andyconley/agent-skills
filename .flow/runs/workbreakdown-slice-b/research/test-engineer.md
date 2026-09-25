# Test engineer: proof strategy for Slice B

Role report for Slice B solutioning. Read-only. It covers AC-R3.* and AC-R4.*. Line references are to the skill, validator and Slice A run records at release 1.5.0.

## Which checks are mechanical, release-check or judged, per criterion

### AC-R3.1: consolidation runs, with an opt-out

- **Mechanical.** The validator already checks the shaping and sources schema. Add a pin that the Draft output announces the consolidation check. The closest existing anchor is the divergence-list contract (work-breakdown-sop.md:44).
- **Release check.** The FX-E3 solo run must say the check ran, and the opt-out run must say it didn't.
- **Judged.** None. This is a presence or absence check on text, so keep it mechanical with `require_text` and `reject_text`, as Slice A did. It needs new prose, because jira-change-protocol.md has nothing equivalent yet.

### AC-R3.2: owner proposal for FX-COLLISIONS

- **Mechanical.** Schema 4 needs the new confirmed-owner block, extending the schema-4 example (manifest-contract.md:255-337). The validator checks that the block is present, closed in shape, and marked `proposed` until the lead confirms. The closed-shape pattern is at manifest-contract.md:28-45.
- **Release check.** The FX-COLLISIONS case parses the owner block's `status: proposed` and its rationale text.
- **Judged.** Whether the rationale is sound. Keep the tolerance loose: present and not generic, rather than correct. This is the same caution as R2.5's judged component-Story pattern: denylist regexps drift with wording (HANDOFF.md:76).

### AC-R3.3: rank order, exceptions, and the unknown negative control

- **Mechanical.** The exception list is data (ref and reason), so the validator can enforce its shape once the schema is set.
- **Release check.** The FX-EXCEPTIONS case parses whether each later-to-earlier edge has a matching exception entry or is flagged as a defect. The negative control is that a run with no rank reports "unknown", checked as an exact string.
- **Reuse.** This is the closest match to R3's dependency-invariant checks, which are already mechanical (manifest-contract.md:442-452). Extend Audit item 3 (jira-change-protocol.md:31) to reuse that edge-list logic instead of judging it again.

### AC-R3.4: FX-COPY-ACCEPT

This is judged, but only narrowly:
- A missing forward edge is mechanical: an edge-list diff, the same machinery as R3.3.
- Misplaced acceptance, meaning acceptance on the Epic rather than alongside the forward edge, is a structural check on the manifest's mapping of Epics to children, not free text. Pin it as mechanical once the schema-4 owner and acceptance block exists; don't leave it to prose judgment.

### AC-R4.1 to R4.4: Audit semantic findings

All four are underspecified today, because Audit's output is a numbered prose list (jira-change-protocol.md:27-41, items 1 to 12). None of those items produces a structured record that can be checked. They are headings that a model writes prose under.

Before building, restructure Audit output as a findings array that parallels Review's existing schema (manifest-contract.md:484-505: category, ref, correction):
- Add the categories `reversed-link`, `terminal-link`, `text-only-blocker` and `status-contradiction`.
- Give each finding a `ref` and `evidence`, the evidence being quoted ticket text (jira-change-protocol.md:121).
- Give link findings a `classification` and a `citing` (author, date).

That turns R4.1 to R4.4 from judged prose matching into mechanical presence and shape checks against an expected finding set frozen with the fixture. Prose matching is Slice A's known failure mode: denylist regexps "miss or misidentify if Jira wording drifts" (HANDOFF.md:76).

- **Release check.** One fixture case each: FX-REV-LINKS, FX-DONE-LINK, FX-TEXT-BLOCKERS and FX-STATUS. The parsed fields are each finding's `ref` and `category`, matched against the expected set.
- **R4.4.** "Status category, no project status names" can be checked with grep: `reject_text` for literal status names, the same technique as Slice A's public-safety grep.

### AC-R4.5: link classification (flagged as ambiguous now)

This is the criterion most likely to be stale or underspecified before building.

Maintainer answer 4 says classification comes from changelog author and date plus ticket text, and is `unknown` when intent isn't evident. But nothing pins who decides the ground truth: that FX-REV-LINKS is `mechanical` and FX-SCOPE-LINKS is `scope-disagreement`. Put differently, nothing says which changelog pattern separates someone fixing a wrong link from someone disagreeing about a link's direction.

**Recommendation.** Before building, have the maintainer, not the model, write the exact changelog shape that separates the two classes for each link event in the 52-card fixture: author role, whether a comment exists, and the time gap. Encode it as an expected-output file alongside the fixture, not as a prose description. Otherwise this repeats the R1.3 FX-STALE-2 problem: a judgment call that passed about half the time and was accepted as residual risk (HANDOFF.md:70-72, validation-results.md:153).

The negative control is fully mechanical once the classification field exists in the finding schema: with the history removed, both links classify as `unknown`.

### AC-B-precision: FX-FORWARD-OK is not reported

This is a mechanical negative control once the findings array exists: assert that no finding has that ref. It is the same technique as the R2.5-control negative control (HANDOFF.md:50).

## Recommended Audit output restructuring

Replace the 12-item prose list (jira-change-protocol.md:27-41) with a structured findings block. Each finding has a category, a ref and evidence given as quoted data. Link findings also carry a classification and a citing.

Reuse Review's existing findings shape (manifest-contract.md:484-509) rather than inventing a parallel format.

This is the single highest-leverage change. It makes R4.1 to R4.4, and half of R4.5, mechanically checkable where they would otherwise be judged and drift. Only R4.5's ground truth then needs a judged tolerance rule, the existing 2-of-3 rerun rule (validation-results.md:8), once the fixture's expected classification is pinned.
