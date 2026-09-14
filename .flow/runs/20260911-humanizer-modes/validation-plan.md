# Validation plan — approved
Status: approved by Andy Conley with the plan. Owner responsibilities become concrete assignments before implementation dispatch.

## Baseline and mechanical evidence
Implementation owner records canonical HEAD, worktree HEAD, dirty state, installed symlink targets and humanizer version before mutation. Run from implementation root:
- bash -n install.sh scripts/*.sh tests/*.sh
- ./scripts/validate-skills.sh
- ./tests/install-test.sh
- ./scripts/lint-prose.sh (existing interface for baseline; new --profile repository after change)
- git diff --check
Record baseline failures separately; don't broaden scope to unrelated release/installer cleanup. Post-change add ./tests/lint-prose-test.sh. Check --help on changed wrapper and skill manager. Version/manifest/frontmatter/body and referenced local policy existence must agree.
Fake-Vale tests assert exact selected config and target argv; paths with spaces and option delimiters; missing tool/config/target, invalid profile/options; profile findings versus execution failures. Real Vale probes confirm actual selected config behavior using one deliberately defective engineering sample and a legitimate personal sample. Negative fault check: route personal to engineering or break target mapping, confirm relevant test fails, restore before commit. Record any semantic failure modes not mechanically tested.

## Six behavioral groups, in both Codex and Claude
A. Engineering defaults: no mode and generic naturalness; seeded bad construction repaired; exact technical spans/caveats preserved.
B. Personal minimal edits: explicit name and equivalent intent; source humor/admission/cadence/digression retained; seeded ambiguity/repetition corrected; clean text preserved. Reviewer logs reason for each meaningful changed span; no method narration required in user output.
C. Paired constructions: same clear deliberate rhetoric under engineering and personal, edit and audit. Personal is not flagged solely for form; engineering removes absent technical reason.
D. Purpose/selection: whole runbook with conversational introduction; personal narrative with incidental command/list; material ambiguity. Metadata names reader's operational task, not just syntax. Classification applies to audit too. Protected spans exact.
E. Audit: clean/defective under each policy, engineering default even on journal content absent explicit personal request. Findings have quote/location, pattern, reader consequence and repair direction. Omission locates affected passage and names missing info; never fabricate quote. No replacement draft, source changes, score or authorship inference.
F. Strict/pattern context: personal strict with valid source voice; available/unavailable/inapplicable tool paths are distinguished; no fictitious factual verification. Positive/legitimate cases for portability, colon reveals, trailing analysis and formatting. Nearby evidence/necessary transitions prevent false positives.
Existing doc-flow-review cases also run unchanged, including review-only scope and output discipline. Existing engineering technical exceptions and mixed-document cases remain regression requirements.

## Evidence records
Store at .flow/runs/20260911-humanizer-modes/validation/<runtime>/<case-id>/ with prompt, actual output, runtime/observed model when available, loaded skill version/path and input/output checksums where useful, selected/expected policy and per-check pass/fail. Keep source/expected/check artifacts separate; do not feed desired output assertions as rewriting instructions. Sanitized summaries in git; no auth/config dumps. Baseline old-contract runs are diagnostic only, not a gate requiring new personal behavior to pass.
Use actual local Codex exec and Claude print in fresh sessions. Local help confirms both entry points; do not disable skills, paste the skill as a replacement for loading, or use unrestricted bypass flags. Limit runtime activity to reading constructed drafts/policy and returning output; coordinator captures output. Each independent default/mode-selection case needs fresh state to prevent a previous personal instruction changing default behavior.
Premerge cases run candidate policy from the worktree with explicit path evidence; installed-path semantics remain unverified until final installation. Test installer support resolution using temporary AGENT_SKILLS_CODEX_DIR and AGENT_SKILLS_CLAUDE_DIR; no global repointing. After merged canonical install, repeat behavioral groups in both fresh installed runtimes and inspect output and loaded policy path. Version self-report alone is insufficient without load/path evidence. If live auth, permission, loading or behavior fails, record unresolved blocker and do not call complete.

## Review, remote and installation
Independent reviewer assesses final diff, evidence and technical/personal preservation. Required CI checks on exact PR head pass before merge. Verify merge commit, release workflow outcome/tag/changelog if emitted; pull canonical main safely. Commit or preserve generated evidence before install.sh clean-tree precondition; do not delete evidence to make installation pass. ./install.sh --all --no-vale when Vale presence is reconfirmed. Verify managed symlink and references/policy.md readback for both runtime targets, installed version matches merged source, and fresh live groups pass.
Postmerge evidence can be added through a narrow follow-up evidence PR if generated after original merge; avoid infinite evidence-commit/live-rerun loops when product hashes are unchanged. Runtime tests validate skill/policy hashes, not unrelated evidence-only commits. If product changes, rerun affected checks.

## Finish
One coherent delivered change with PR/merge evidence, successful canonical installation and live evidence in both runtimes. Static checks never substitute for semantics or installed loading. Quality claims limited to exercised constructed cases; no personal-writing satisfaction claim beyond that evidence.
