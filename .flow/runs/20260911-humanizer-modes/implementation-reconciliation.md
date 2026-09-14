# Implementation reconciliation

Date: 2026-09-14. Work ID `20260911-humanizer-modes`. Status: resolved with named residual risks.

- The original semantic gate required every Claude and Codex assertion to pass. Andy Conley explicitly changed the delivery instruction to “best effort release with the known failures documented.” The full source-admissible candidate run and independent review found failures; no failed assertion was relabeled as passed. `acceptance-deviation.md`, `validation-results.md`, and the release PRs carry the disposition.
- The first installed 4.8.0 Claude run reported missing shared references. This was a structural packaging defect, not waived model behavior. PR #16 packaged local readable references; final 4.8.1 installed Claude tool traces read all three successfully. `validation/installed-4.8.0.md` and `validation/installed-4.8.1.md` separate the before and after evidence.
- The 54-call suite predates the final 4.8.1 entry/policy hashes. Static checks were rerun on the final source, and 10 source-admissible installed calls verify selected affected behavior and loader paths. The prior suite is historical coverage, not a full final-hash semantic pass. Unknown behavior outside those selected calls remains a documented release risk.
- The previously untracked canonical Flow run was moved intact to `/tmp/agent-skills-canonical-run-pre-merge-20260914` before the main checkout fast-forward. The tracked run and current canonical checkout are clean, and the backup remains available. No conflicting user edit was discarded.

There is no unresolved cross-role conflict. Independent quality review approves the packaging repair and release only within the explicit best-effort deviation; it does not claim universal semantic acceptance.
