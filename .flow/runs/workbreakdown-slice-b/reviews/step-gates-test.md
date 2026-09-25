# Step-gate test reviews: workbreakdown Slice B

## C1 coverage review (5759fd8)

A read-only pass by the test-engineer role.

It found 12 validator rules that no test would catch if deleted. They included shape guards, the claim-text check, the blocker side of the endpoint check, and the list type guards. All are covered in 42cc5d0.

The "order key matches a child ref" rule turned out to be unreachable, because order keys must be Jira keys. It was removed together with its prose clause.

## Mutants

Every named mutant from M40 to M70 was run on a committed tree, judged by the suite's exit code, and restored. All were caught. `validation-results.md` lists each mutant with the test that caught it.

## Release-check self-test

Each gate run's first attempt was doctored once for each targeted check. Every mutant flipped its check from pass to fail, with none missed, across all 15 runs of the final gate.

Two mutants were added for the checker fixes:
- `S1-spill`: a spilled tool result from another workspace is still refused.
- The heading form of the consolidation label.
