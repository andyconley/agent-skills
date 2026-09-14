# Full Claude fixture review

Date: 2026-09-14. Reviewer: test-engineer. Candidate: `candidate-best-effort-full/claude`.

## Evidence admission

All 27 case directories have a `meta.json` with `status: 0`, `admissible: true`,
`source_changed: false`, and the runner's required source reads recorded. The
humanizer cases recorded the candidate entry and common policy reads; the
doc-flow cases recorded the candidate entry read. This establishes that the
outputs below came from the candidate source under the runner's admission rule.
It does not prove every editorial rule was applied; the verdicts below compare
the output with the fixture oracle.

## Verdicts

| Case | Result | Material evidence |
| --- | --- | --- |
| `engineering` | Pass | Keeps `` `retry.log` ``, `15 seconds`, and `We have not measured recovery under load.` It removes `What I concluded` and does not invent the trace referent; it identifies that span as unresolved. |
| `natural-default` | Pass | Engineering edit uses `Disable`, `Configure`, and `perform`; it retains `The timeout stays 15 seconds.` |
| `personal` | Pass | Removes one repeated `I had put it in upside down.` and retains the bookcase joke, brother digression, and `Mostly.` ending. |
| `equivalent` | Pass | The clear-equivalent personal request retains `My first read ... wrong` and `set up`; only the duplicate `Mum would have laughed.` is removed. |
| `personal-clean` | Pass | Returns the source unchanged and does not request a voice sample. |
| `personal-technical` | Pass | Retains `` `systemctl stop demo` ``, `"port already in use"`, the unmeasured-restart caveat, and the `Patience ... installing` joke. |
| `personal-runbook` | Pass | Correctly overrides the personal request for a runbook: `Disable`, `Configure`, and `Perform` replace the procedure verbs; `Do not delete `retry.log`.` and the `15 seconds` timeout survive. |
| `audit-engineering` | Pass | Locates both `What I concluded:` and `This is a pivotal moment, highlighting our commitment to reliability.`, names reader cost, and gives repair direction without a replacement draft or authorship claim. |
| `audit-personal` | Pass | Returns only `No actionable findings.` for a clean personal passage. |
| `audit-clean` | Pass | Returns only `No actionable findings.` for the clean engineering audit. |
| `strict-personal` | **Fail** | The duplicate is removed and personal `set up` remains, but the output gives no available/unavailable/inapplicable validation status despite the fixture's explicit strict-status check. |
| `portability` | Pass | Flags only the generic `better experience` and unsupported `The best part: it works.` It leaves the supported retry statement, list colon, and parser trailing clause unchallenged and invents no metric. |
| `ambiguous` | Pass | Asks one focused purpose question: whether the two imperatives are operator instructions or a memoir beat. |
| `doc-flow` | Pass | Provides structural reader costs and directions (`Evidence → Constraint → Options → Recommendation`), does not rewrite, and preserves the offline/evidence facts. |
| `paired-engineering` | **Fail** | It changes the first-person framing, but returns the defective source sentence verbatim: `It kept going, and so did I.` The engineering fixture requires removal of that decorative mirroring. |
| `journal-default` | Pass | Engineering audit identifies `It kept going, and so did I.` as mirrored/aphoristic and gives direction without rewriting. Its additional author-state finding does not contradict the fixture's allowance that concrete error ownership may remain. |
| `audit-omission` | Pass | Identifies `obtain approval` as lacking an approver/authority and directs the writer to identify it; it does not fabricate an approver or a missing quote. Additional listed operational gaps remain framed as omissions. |
| `strict-file` | **Fail** | It reads the actual `draft.md` and removes the duplicate while retaining `My first read was wrong` and `set up`, but the event log contains no `Bash` call to `scripts/lint-prose.sh --profile personal -- <target>`. The file-target strict fixture explicitly requires invoking the personal profile. |
| `strict-restricted` | Pass | It removes only the duplicate, retains the admission and `set up`, and accurately says `Mechanical validation (Vale/lint) was not run under this restriction`. |
| `protection-engineering` | Pass | All exact command/path/quote/citation/setting spans survive and the unprotected `I wanted **one** quiet evening.` is removed. No technical behavior is invented. |
| `protection-personal` | Pass | All protected spans survive and the personal `I wanted **one** quiet evening.` remains unchanged. |
| `audit-formatting` | **Fail** | Returns `No actionable findings.` even though `**The worker** **retries** **failed uploads**` applies emphasis to every part of the first sentence. The fixture requires that specific excess-markup diagnosis while retaining the distinct `**one**` emphasis. |
| `regression-protected` | Pass | Preserves both opposing `DO NOT` / `DO` storage obligations, all three code spans, and both executed-evidence sentences without causal additions. |
| `regression-word-choice` | **Fail** | It deletes the source's `Older than six months?` threshold and `The rollback is pretty fast.` instead of retaining the threshold and saying the rollback duration is unknown. It also collapses source-distinct `job` and `task` into `job` without evidence that they are the same concept. |
| `regression-mixed` | Pass | Uses plain verbs throughout (`Disable`, `Restore`, `Perform`) and retains the no-retry/no-visibility argument and `three overnight runs this quarter`. |
| `doc-flow-strict` | Pass | Identifies the context/implementation order and unresolved custom-retry risk, provides repair direction, and remains review-only. |
| `doc-flow-normal` | Pass | Identifies `Context` ordering and the unsupported connection between the implementation claims and tracing problem, with concrete repair direction and no rewrite. |

## Result

**22 pass, 5 fail, 0 uncertain.** The candidate is not acceptance-ready. The failures are material behavior gaps, not style preferences:

- strict validation status is absent for `strict-personal`;
- file-target strict work never invokes the required personal lint profile;
- personal audit misses the explicit excessive-formatting defect;
- engineering edit leaves the paired mirrored construction intact;
- runbook rewriting loses a numeric threshold, merges unsupported terms, and silently drops the rollback-duration uncertainty.

The raw output and event evidence remain under
`validation/raw/candidate-best-effort-full/claude/<case>/`.
