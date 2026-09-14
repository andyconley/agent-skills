# Technical writer handback review

## Documentation Update Summary

### Audience

- Skill users who need a predictable engineering rewrite, an explicitly requested personal edit, or an audit without a replacement draft.
- Maintainers who need to understand the source of truth, supported invocation language, validation commands, and the boundary with `doc-flow-review`.

### Changes Needed

- The current `README.md`, `docs/README.md`, and `tests/manual/humanizer.md` describe the approved contract coherently: engineering is the default, personal mode is explicit, audit is separate, protected material survives, and `doc-flow-review` remains review-only.
- Keep the local policy link in the README and the corresponding required reference in `skills/humanizer/SKILL.md` synchronized. The policy file is the canonical mode and disposition matrix; avoid duplicating that matrix in general documentation.
- Before handback, update the manual-test section only if the final live evidence changes the supported prompt language or validation caveats. It should continue to point to constructed fixtures and require recorded outputs, loaded skill/policy paths, runtime versions, and per-check observations.
- On release, let semantic-release generate changelog text from the Conventional Commit. Do not add a hand-written changelog entry that duplicates the README contract.

### Drift or Ambiguity

- The documentation is accurate for the implemented source contract, but it must not imply that candidate or temporary-install runs are shipped or that static Vale results prove voice quality.
- `README.md` says strict mode uses applicable Vale checks when available and reports missing tools accurately. Final evidence must preserve that distinction for the strict-personal available, unavailable, and inapplicable cases.
- The manual test currently directs maintainers to run constructed cases in fresh Codex and Claude sessions. The final handback must identify which evidence is candidate, installed, and post-merge; do not collapse those states into one claim.
- The approved plan's delivery requirements remain pending until the PR, CI, merge/readback, canonical sync, install, and fresh installed-runtime checks are complete.

### Recommended Wording or Structure

Keep the current documentation structure. The durable handback should link these canonical surfaces:

1. `README.md` for user-facing behavior, invocation examples, installation, and development commands.
2. `docs/README.md` for the strategy and boundary between `doc-flow-review` and `humanizer`.
3. `skills/humanizer/SKILL.md` for resolution order and execution workflow.
4. `skills/humanizer/references/policy.md` for mode, purpose, protection, audit, and lint dispositions.
5. `tests/manual/humanizer.md` and `tests/fixtures/humanizer/cases.json` for behavioral evidence requirements.

Completed documentation review: source docs and policy references agree with the approved requirements and plan.

Pending handback evidence: independent quality verdict after the latest live outputs; technical-writer handback should be refreshed if the final runtime results require wording changes; release, installation, and post-install live checks are not complete at the time of this report.
