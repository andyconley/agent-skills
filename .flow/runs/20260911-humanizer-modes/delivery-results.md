# Delivery execution, readback, and comparison

Date: 2026-09-14. All shared writes were serialized by the coordinator after orchestration dispatch checks. The baseline was captured in `delivery-baseline.md`; final readback follows.

## GitHub

Baseline: `origin/main` `37fc25e`, release v1.5.1, no humanizer PR. Execution: feature branch `b37b9ae` -> [PR #15](https://github.com/andyconley/agent-skills/pull/15) -> squash merge `111f8c9` -> [v1.6.0](https://github.com/andyconley/agent-skills/releases/tag/v1.6.0). Installed validation found a shared-reference packaging defect. Patch branch `211e164` -> [PR #16](https://github.com/andyconley/agent-skills/pull/16) -> squash merge `5221c96` -> [v1.6.1](https://github.com/andyconley/agent-skills/releases/tag/v1.6.1) at `4dd2f66`. Both PR CI runs, main CI, and release workflows concluded success. Readback: latest release v1.6.1 and final main tag v1.6.1. Comparison: the planned single release became two because a real installed-path defect required a patch; the unexpected delta was resolved by PR #16 and verified installed reads. Git history and tags retain recovery points.

## Canonical checkout

Baseline: `/Users/andyconley/Documents/agent-skills` at `5140bab` on main with an older untracked run. Execution: moved that run intact to `/tmp/agent-skills-canonical-run-pre-merge-20260914`, then fast-forwarded main through both releases. Readback: clean canonical checkout at `v1.6.1`, commit `4dd2f66`; no tracked user edit was overwritten. Comparison: expected main sync and run preservation achieved. The backup remains available for recovery.

## Installed skills

Baseline: both humanizer links resolved to the canonical 4.7.0 skill; doc-flow-review links were canonical, workbreakdown links absent. Execution: `./install.sh --all --no-vale` after v1.6.0 and again after v1.6.1. Readback: `~/.agents/skills/humanizer` and `~/.claude/skills/humanizer` resolve to the canonical source at 4.8.1, entry SHA-256 `61c6d7577d99f8debc557b1abbbb066369e5462df14c45164ec62204f9c7f293`, policy SHA-256 `53a8a9b787777f4ce0d011fdb1dfd4075c943947801760f97abd8aa3c3565cf2`; the policy and three shared reference links are readable and byte-identical through both runtime paths. `doc-flow-review` and `workbreakdown` managed links exist in both runtimes. Comparison: the first 4.8.0 install exposed the broken shared-reference path; the 4.8.1 package repaired it, as confirmed by a fresh Claude Read trace. Reinstall from clean canonical checkout remains available as recovery.

Behavioral limits are in `validation-results.md` and `validation/installed-4.8.1.md`; successful structural readback does not imply semantic passage.
