# Humanizer implementation architecture remedy

Status: bounded implementation consultation. This note recommends one reversible instruction-layout experiment. It does not change the approved requirements, accepted local ownership boundary, or product files.

## Problem

The candidate implements the approved local policy matrix and one entry resolver. Codex consistently applies the intended mode boundaries in the inspected candidate runs. Claude still crosses those boundaries in several fresh runs despite reading the required entry point and policy:

- `candidate-closed/claude/journal-default` returns `No actionable findings.` under default engineering audit, although the unprotected mirrored close is a seeded engineering defect.
- `candidate-closed/claude/audit-formatting` uses a broader finding location than the fixture requires, but its repair direction explicitly preserves the meaningful `**one**`. This is a low-severity precision issue, not evidence that Claude selected the wrong mode.
- `candidate-regression/claude/regression-word-choice` leaves both `job` and `task` and rewrites `pretty fast` as `fast` instead of stating that rollback duration is unknown.

One apparent failure has a different cause. `candidate-closed/claude/protection-engineering` invoked the native installed humanizer 4.7 skill and never loaded the requested worktree entry point. Its failed references resolved under `~/.claude/skills/shared`. That output is invalid as candidate semantic evidence and must not support this architecture decision. The trace inventory found this narrow harness defect in one run; the other inspected candidate release, gated, and regression runs loaded the explicit candidate files.

The two substantive source-correct failures are `journal-default` and `regression-word-choice`. Both match rules that are present in the candidate and were loaded in their traces. Missing policy text is therefore a weak explanation for those cases. The more plausible layout problem is competing instruction activation: `references/policy.md` presents both complete mode contracts, their exceptions, examples, audit rules, and strict rules in one required read. Some Claude runs then read the shared engineering pattern and final-gate files as well. The model must retain the resolved mode while repeatedly encountering applicable-looking rules from the other mode.

This is a causal hypothesis, not a confirmed diagnosis. The evidence is a small set of constructed runs from two model families. It does not isolate instruction order from model variance, prompt interpretation, sampling, or remaining harness effects. A source-loading gate followed by a layout-only experiment is needed before changing policy meaning again.

## Constraints

- Keep artifact policy inside humanizer. Do not create a shared multi-skill profile framework.
- Keep one resolver in `skills/humanizer/SKILL.md`.
- Keep `skills/humanizer/SKILL.md` solely authoritative for resolution order, precedence, purpose override, mode, operation, and intensity.
- Keep `references/policy.md` authoritative for common protections and the policy matrix after the entry point has resolved the request.
- Preserve shared commentary and `doc-flow-review` behavior.
- Do not add another model judge or claim model-perfect behavior.
- Avoid another round of scattered prohibitions. New wording must represent an approved rule or an existing fixture disposition.

The approved plan names one local policy file, but the accepted boundary is humanizer-local ownership rather than a permanent one-file limit. Additional selected-mode references remain within that boundary if they contain execution detail only and cannot resolve or override mode. This is a reversible implementation-layout adjustment and does not require a new product decision.

## Options considered

### Add more prohibitions to the current files

Append explicit reminders for the four failed cases to `SKILL.md` or `policy.md`.

This has the smallest diff, but the candidate already contains the relevant rules. More reminders increase instruction competition and make later failures harder to diagnose. Reject this option.

### Inline both mode contracts in `SKILL.md`

Move the policy detail back into the entry point and put the selected branch close to the resolver.

This removes a required reference read, but every run still loads both conflicting mode contracts. It also reverses the accepted readability improvement and recreates the long, repeated entry point. Keep this as a rollback-safe alternative only if reference loading itself proves unreliable.

### Split execution detail by selected mode

Keep the common policy and matrix in `references/policy.md`. Move the existing engineering execution detail to `references/engineering.md` and the existing personal execution detail to `references/personal.md`. After the entry point resolves the effective mode, it requires exactly one of those files.

This reduces simultaneous conflicting instructions without changing the semantic contract. It keeps resolution centralized and makes the selected policy the most recent detailed instruction before editing or auditing. This is the recommended experiment.

## Recommended layout

### `skills/humanizer/SKILL.md`

Own only:

- required common-policy load
- protection and missing-policy fallback
- ordered resolver
- required selected-mode load
- shared edit/audit response shape
- strict lint adapter invocation

The resolver records effective mode, operation, and intensity. It then loads exactly one execution capsule. It must not repeat mode dispositions after selection.

### `skills/humanizer/references/policy.md`

Remain authoritative for:

- non-negotiable protections
- the compact policy matrix
- edit versus audit semantics
- normal versus strict semantics
- final response contract common to both modes

The matrix describes the behavior of already resolved dimensions; it does not resolve or override them. Remove detailed mode sweeps, mode-specific examples, and mode-specific closeout gates from this file after moving them. A row in the matrix points to the owning execution capsule rather than restating its full policy.

### `skills/humanizer/references/engineering.md`

Contain the existing engineering purpose branches, construction dispositions, STE discipline, engineering final gates, and engineering examples. It may require `shared/pattern-classes.md` and `shared/final-gates.md` because those definitions are part of the engineering artifact policy.

End with one compact engineering closeout card derived from current rules:

1. Remove unprotected personal wishes, moods, and preferences that carry no technical information.
2. Hold one term for one concept across the complete artifact.
3. Replace a vague measurable adjective with the known number or state that the number is unknown.
4. Preserve every protected span and caveat.
5. Return only the contractually allowed output.

These are existing requirements, not new fixture-specific prohibitions.

### `skills/humanizer/references/personal.md`

Contain the existing minimum-effective-edit rule, source-trait identification, personal construction dispositions, deletion/portability treatment, personal examples, and personal final gates. Do not require the shared engineering pattern or final-gate files for personal artifact evaluation. The entry point already carries the short response contract needed around the artifact; shared agent-output discipline remains the source contract for commentary but must not be reapplied to personal source prose.

End with one compact personal closeout card derived from current rules:

1. Every changed span has a reader problem or satisfies the user's explicit request.
2. Every named source trait and purposeful local emphasis remains unless it causes that problem.
3. Exact protected material and uncertainty remain unchanged.
4. Audit findings identify the defective span only; nearby legitimate emphasis is excluded from the finding location.
5. Return only the contractually allowed output.

## Processing boundary

The intended data flow is:

```text
request + source
  -> common protections and purpose classification
  -> one resolver decision
  -> one selected-mode execution capsule
  -> edit or audit
  -> selected-mode closeout
  -> response gate
```

Shared engineering definitions are an engineering-branch dependency. They are not a second policy layer over personal artifacts. Vale remains an optional adapter after semantic resolution and does not participate in this experiment.

No state, service, schema, or installation model changes. The installer already links the humanizer directory, but packaging validation must add both selected-mode references to its required-path and resolved-symlink checks.

## Bounded experiment

Fix evidence admission before changing the instruction layout. For premerge explicit-path runs, prevent native Skill lookup while leaving file reads enabled. Do not disable all slash commands and do not paste the skill into the prompt. Score a candidate run only when its trace proves that it read the expected worktree `SKILL.md`, `policy.md`, and selected-mode capsule with the recorded candidate hashes. Treat a native installed-skill invocation, a missing required read, or a path/hash mismatch as a harness failure rather than an editorial result. Installed postmerge runs continue to use native skill loading and must prove that the installed 4.8 path and references loaded.

Make a layout-only patch first:

- Move existing mode-specific text into the two selected-mode references.
- Change links and required-read instructions.
- Add the two closeout cards using only already approved rules.
- Do not add new pattern rules, change fixture expectations, modify shared files, or change Vale profiles in the same patch.

Run this targeted Claude battery after the source-loading gate passes:

1. Run `journal-default` and its same-source `audit-personal` control once. Engineering audit must report the mirrored closing; personal audit must remain clean.
2. Run `regression-word-choice` once. The procedure must use one term for the work unit and one term for the directory; rollback duration must be stated as unknown rather than `fast`.
3. Run source-correct `protection-engineering` and its same-source `protection-personal` control once. Engineering must remove the unprotected wish while preserving exact technical spans and returning no routine notes. Personal must preserve the purposeful wish and emphasis.
4. If the first battery passes, repeat only `journal-default` and `regression-word-choice` in fresh sessions because those are the two source-correct substantive failures that motivated the layout change.

Run the two paired controls once in Codex to detect a mode-isolation regression. Record prompts, outputs, entry/policy/capsule hashes, loaded paths, and per-assertion results as the existing validation plan requires.

The experiment passes only if the first battery, the two focused Claude repeats, and the Codex controls satisfy their case assertions. This tests the observed boundaries without rerunning the complete suite repeatedly; it does not guarantee future model behavior. After a passing candidate experiment, continue with the approved release validation once, including the full installed-runtime suite after merge and installation.

If the experiment fails, revert the layout patch as one unit. Do not respond by adding case-specific warnings. Compare failed traces for skipped selected-mode reads or shared-file re-entry. If the selected capsule loaded and the same cross-mode error persists, the evidence does not support instruction separation as the remedy; return to architecture review before changing semantics.

If it passes, run the complete approved candidate and regression suites in both runtimes. The full suite remains the release gate.

## Risks and mitigations

- **Reference loading can fail, be skipped, or be displaced by the native installed skill.** Keep the existing explicit missing-policy failure, extend packaging validation to both capsules, deny native lookup only for premerge explicit-path candidate runs, and reject any result without expected path/hash evidence.
- **Policy ownership can drift across four files.** Keep all resolution and precedence solely in `SKILL.md`; keep the common matrix in `policy.md`; selected capsules contain execution rules only. Validate that `policy.md` and neither capsule defines selection or changes precedence.
- **Shared output rules can still contaminate personal artifacts.** Do not require shared engineering class/gate reads from the personal branch. Keep the local response gate short and apply it after artifact evaluation.
- **A passing repeated test can create false confidence.** Limit claims to the four repeated cases and retain the complete two-runtime release suite.
- **Moving text can accidentally change meaning.** Review the patch as a move plus link changes. Compare retained requirements and examples before running live tests.

## Decision

Proceed with the selected-mode execution-capsule experiment. It is the smallest change that tests the strongest evidence-backed hypothesis while preserving the accepted humanizer-local architecture. It is reversible as one patch and has a clear stop condition. Do not widen shared policy or add further prohibitions unless this controlled layout change fails and new evidence identifies a different boundary problem.
