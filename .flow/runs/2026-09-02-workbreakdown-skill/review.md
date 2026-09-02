# Implementation Review

## Evidence inventory

- Skill behavior: `skills/workbreakdown/SKILL.md`
- Canonical policy: `skills/workbreakdown/references/work-breakdown-sop.md`
- Manifest authority and schema: `skills/workbreakdown/references/manifest-contract.md`
- Jira Audit and Apply protocol: `skills/workbreakdown/references/jira-change-protocol.md`
- Package metadata: `skills/workbreakdown/VERSION`, `skills/workbreakdown/agents/openai.yaml`, `skills/manifest.tsv`
- Distribution proof: `tests/install-test.sh`
- Static contract proof: `tests/workbreakdown-contract-test.sh`
- Behavior cases: `tests/manual/workbreakdown.md`
- Approved requirements and plan: `.flow/runs/2026-09-02-workbreakdown-skill/`
- Search method: inspected the complete Git diff, all new skill files, existing installer and validation scripts, public documentation, and source SOP.

## Findings and dispositions

1. **Missing sizing rule:** The first implementation omitted creating known work early and marking estimates provisional while blocking Spikes remain open. Restored in the canonical SOP and asserted by the contract test.
2. **Live-drift proof gap:** The first manual suite tested unrelated-state preservation but not material drift refusal. Added a dedicated zero-write drift case.
3. **Ambiguous existing-item verification:** `existing.verify` was optional while summary and completion expectations were required. Made `verify` mandatory.
4. **Untrusted Jira content:** Jira fields and supplied artifacts could contain instructions. Added an explicit instruction/data boundary and a prompt-injection refusal case.
5. **Overbroad mutation fields:** Added a v1 allowlist for summary, completion, evidence, and estimate. Explicitly prohibited destructive, hierarchy, workflow, security, and non-`Blocks` mutations.
6. **Out-of-scope dependency mutation:** Required at least one dependency endpoint to be a manifest child and bound removals to the exact observed link.
7. **Approval identity and resumption:** Defined digest bytes, made scope changes require new Review and approval, and made partial-operation resumption a new preflighted Apply attempt.

## Verdicts

- Quality review: accepted after fixes.
- Security review: accepted after fixes.
- Architecture: three-reference split and host-neutral packaging accepted; deterministic mutation safeguards incorporated.
- Remaining actionable findings: none.
