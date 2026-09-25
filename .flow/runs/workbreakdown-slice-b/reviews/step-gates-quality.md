# Step-gate quality reviews: workbreakdown Slice B

Every review was a read-only pass by the quality-reviewer role. Every Important finding was fixed and re-gated before the next step.

## C1: consolidation block (5759fd8)

Verdict: request changes.

**Important findings, all fixed in 42cc5d0:**
- An exception's ticket and its Epic were not tied together.
- The worked example excused an edge that could not exist.
- Mutants were missing for several error fragments.

**Suggestions:**
- **Adopted:** reject duplicate exceptions and duplicate claims, test an omitted order, reorder the non-map order error, and say "nonempty" in the prose.
- **Not adopted:** making the scoped Epic a required claimant. The prose now states that claims may be between any Epics.

## C2 and C3: Draft consolidation and graph checks (93a3b77, 1535a9e)

Verdict: request changes.

**Important findings, all fixed in 9cf0e76:**
- Each status needed an explicit mapping to its output label.
- Graph-check item 11 needed an outcome for an unknown or partial order, and for a check that did not run.
- A supplied exception outside a known order, and a proposed exception, had nowhere to go.
- The scope of a claim was unclear.

**Suggestions adopted:**
- a declared order that omits the scoped Epic
- an explicit opt-out phrase
- an Epic ticket counting as its own Epic
- a definition of the lead
- a missing Initiative parent

## C4: Audit semantic link findings (ed51a4f)

Verdict: request changes.

**Important findings, all fixed in 4a85617:**
- Audit needed its own source for milestone order and exceptions.
- The scope of the forward-edge exemption was unclear.
- A reversed link could be reported under two checks.
- Status names in quoted evidence needed a rule.

**Suggestions adopted:**
- done items belong under `into-closed`
- a category rule replaces "rejected"
- the ready statuses are echoed
- unordered edges have a home
- duplicate findings are rejected

## Gate-driven fixes (e26c28a, aed48c6, 85b486e)

These came from release-gate failures, not from a review. `validation-results.md` records each one with the maintainer ruling that led to it.
