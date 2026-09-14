---
name: humanizer
description: Audit or rewrite engineering prose by default, or explicitly requested personal prose with minimum effective edits. Preserve facts and protected text; preserve source voice in personal mode. Use doc-flow-review first for structural review. Version 4.8.1.
---

# Humanizer

**Version: 4.8.1.** Report this value exactly when asked which version is running.

Edit or audit the supplied draft. Engineering mode is the default. It rebuilds AI-shaped prose into direct technical writing. Personal mode is an explicit exception for a personal draft where the user wants minimum effective edits and source voice preserved.

Read [the policy](references/policy.md) before editing or auditing. It is required. If it is unavailable, say that the humanizer policy cannot be loaded and do not claim a compliant rewrite, audit, or validation result.

For an engineering sweep, also read `references/pattern-classes.md` and `references/final-gates.md` before applying a class. They define the classes and gates. A list of class names is not enough.

The policy governs the edited artifact. The shared contract in `references/agent-output-discipline.md` governs your response around it. Personal mode does not change shared agent-output discipline or doc-flow-review.

## Resolve the request

Resolve these decisions in order. Do not let Vale, a phrase match, document genre, first-person narration, or a generic request to sound natural select the policy.

1. Preserve explicit user constraints and protected spans first: facts, uncertainty, obligations, quotes, citations, commands, identifiers, paths, flags, code, configuration, and exact source material.
2. Identify whether the artifact has a substantive operational or reference purpose. If purpose is materially ambiguous, ask one focused question.
3. Resolve the requested mode. Select **personal** only when the user explicitly asks for personal mode, personal writing, a personal note, or a clear equivalent that asks for minimum edits and voice preservation. Otherwise select **engineering**. An unqualified edit or audit of a memoir or diary remains engineering.
4. Resolve the effective mode. A substantive procedure, runbook, checklist, standard, or other operational/reference artifact uses engineering, even when it has a conversational introduction. An incidental command, list, or quote inside a personal narrative remains protected but does not turn the narrative into engineering prose.
5. Select **audit** only when the user asks to inspect, diagnose, or audit without rewriting. Otherwise edit.
6. Select **strict** for `strict`, `high`, `hard pass`, `vale pass`, or `lint pass`. Otherwise use normal validation.

Use the selected policy in [the policy matrix](references/policy.md#policy-matrix). Engineering does not silently become personal because the draft has personality. Personal does not silently become engineering because a construction resembles an AI tell.

Record the effective mode, operation, and validation intensity internally. That record is binding for this artifact. Later examples or rules from the other mode cannot change it.

## Workflow

1. Bind the recorded effective mode, operation, and intensity to the source. Read the protections, policy matrix, and only the recorded mode’s policy section. In engineering mode, read the required shared definitions. Internally mark protected spans, supported claims, material unknowns or ambiguous relationships, and voice traits relevant to that mode.
2. Run the recorded mode’s construction sweep one class at a time, then edit or audit under that mode’s disposition. Do not apply personal allowances to an engineering artifact or engineering mandates to a personal artifact.
3. Compare the result with the complete source before answering. For each output claim, verify its referent, certainty, technical meaning, and protected text against the source. For each retained unprotected sentence, verify that it belongs under the recorded mode. Preserve two source terms as distinct unless task evidence establishes that they name one concept. Re-read the full artifact so a local repair does not damage progression or voice. Revise any mismatch before returning the result.
4. Run the recorded mode’s semantic checks. In strict mode, add an applicable mechanical check when available. Apply the policy’s final response gate; do not report this internal check.

## Edit and audit

For an edit, return the requested rewrite only. Add one concise exception line only for an evidence-supported correction or an unavailable validation that affects the result. You can also quote an unresolved source span unchanged and ask for its exact missing fact. In a limited-span task, report an outside-span repair only when it corrects duplication, a dangling reference, or inconsistent pronouns. Do not add scores, authorship probabilities, policy selection, completed-check reports, method narration, or a preamble.

For an audit, leave the draft and source unchanged. Default to engineering when no writing mode was selected. Report only supported findings. Each finding gives an exact span or unambiguous location, the applicable pattern or problem, its reader consequence, and a short repair direction. Replacement wording is optional. An omission identifies the affected passage and missing information; do not invent a quote. A clean audit says that it found no actionable issues. Do not return a replacement draft, score, or authorship judgment.

Apply comments to the requested span and only the adjacent text needed to repair duplication, a dangling reference, or inconsistent pronouns. Keep the established policy and voice.

## Validation

Normal and strict work both run the policy’s semantic construction sweep, deletion test, portability diagnostic, protection check, and applicable final gates. Strict mode adds the applicable optional mechanical check when it is available; it does not make a skipped or inapplicable check pass.

When a target is a file and the repository wrapper is available, use:

```text
scripts/lint-prose.sh --profile engineering -- <target>
scripts/lint-prose.sh --profile personal -- <target>
```

Use the profile that matches the selected policy. Personal candidates are advisory and never require an engineering-voice rewrite. If Vale, the wrapper, or its configuration is unavailable, complete the semantic checks manually and state the actual limit only when it affects the result. A tool or configuration failure is not a prose finding.

## References

- [Policy matrix and mode rules](references/policy.md) — required for every edit and audit.
- `references/agent-output-discipline.md` — response contract and engineering construction names.
- `references/final-gates.md` and `references/pattern-classes.md` — final gates and diagnostic classes.
