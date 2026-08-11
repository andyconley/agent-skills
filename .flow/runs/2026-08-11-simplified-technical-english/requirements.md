# Requirements — Simplified Technical English

## Origin

A Slack thread at Path Robotics proposed adding ASD-STE100 Simplified Technical English rules to a global `CLAUDE.md`, and separately as an agent output style. Both approaches solve a problem these skills already address, but they cover rules the skills lack.

The work absorbs the applicable STE rules into the existing skills rather than adding a competing standard.

## What STE is

ASD-STE100 is a controlled-language standard from the AeroSpace and Defence Industries Association of Europe. It has two parts: about 65 writing rules, and a dictionary of roughly 900 approved words with one meaning and one part of speech each. The dictionary is the substance of the standard and is licensed.

This work implements applicable rules. It does not ship the dictionary. Output from these skills must not be described as STE-conformant.

## Overlap with the current skills

Already covered at humanizer 4.5.0 and doc-flow-review 1.4.0:

- short sentences — humanizer caps at about 15 words, tighter than STE's 20 and 25
- lead with the answer, no preamble, no recap — `shared/agent-output-discipline.md`
- copy identifiers and quoted text exactly — "Preserve technical truth"
- length matches the work, not the effort — "Do not use a blanket word-count reduction target"

Genuinely missing:

- one term per thing
- plain verbs instead of phrasal verbs
- no idioms as a stated rule
- numbers instead of adjectives

## Conflict and resolution

Humanizer's "Moves that add human texture" prescribes what STE bans: question-as-condition, the shrug close, contractions, conversational rhythm. STE targets a non-native reader working through a maintenance procedure. Humanizer targets a colleague evaluating a proposal.

Resolution: STE rules attach to the reference, checklist, and standard document type. The texture moves stay with argument and analysis documents.

## Decisions

| Decision | Choice |
| --- | --- |
| Form of the change | Core rules folded into the skills. No STE mode. |
| doc-flow-review scope | Terminology consistency only. |
| Vale enforcement | `PlainVerbs` plus a term-drift rule. |
| Governed surface | Documents rewritten **and** the agent's own replies. |
| Term list contents | Generic writing pairs. No Path vocabulary in a public repo. |
| Proof | Regression fixtures, CI, and a live before/after. |
| Mixed documents | Whole document, strictest wins. |
| Surfaces updated | `README.md`, `tools/vale/README.md`, both `agents/openai.yaml`. |

## Out of scope

- an STE mode or strict-mode variant
- the approved-word dictionary
- any claim of STE conformance
- code-comment conventions from the source thread; those belong in a personal `CLAUDE.md`
- procedure and safety ordering checks in doc-flow-review
- Path-specific vocabulary in the public term list
- `install.sh`, the CI workflow, and `manifest.tsv`

## Open questions

None. All ambiguities were resolved before Phase 2.
