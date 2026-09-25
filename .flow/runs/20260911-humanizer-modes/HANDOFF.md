# Humanizer modes implementation handback

Work ID: `20260911-humanizer-modes`. Outcome: delivered as an explicitly approved best-effort release on 2026-09-14.

## Delivered

Humanizer 4.8.1 defaults to engineering edits and supports explicitly selected personal edits that preserve the draft's useful voice with minimum effective changes. Audit and strict validation use the selected mode. The skill has one resolver and a local policy, with shared definitions readable through installed-path reference links. Vale profiles, fixture/packaging checks, installer tests, CI, and user-facing guidance are updated. Shared writing policy and doc-flow-review source remain unchanged.

PR [#15](https://github.com/andyconley/agent-skills/pull/15) delivered the mode feature in [v1.6.0](https://github.com/andyconley/agent-skills/releases/tag/v1.6.0). Installed testing found a broken path to shared definitions. PR [#16](https://github.com/andyconley/agent-skills/pull/16) fixed it in [v1.6.1](https://github.com/andyconley/agent-skills/releases/tag/v1.6.1). Both PR CI runs, main-branch CI, and release workflows passed. The canonical checkout is clean at v1.6.1 and `install.sh --all --no-vale` refreshed the Codex and Claude skill links.

## Proof and limits

Final static checks pass: three skill manifests, 27 fixture definitions and negative controls, 18 installer cases, lint-wrapper tests, workbreakdown compatibility, skill validation, and Vale on 50 files with zero findings. The installed entry and policy hashes match the canonical source in both runtimes; all four local references are readable through both links. A fresh Claude tool trace reads the three previously missing shared files with returned content. This closes the packaging incident.

The complete 54-call candidate suite ran before the final packaging patch. It scored Claude 22/27 and Codex 25/27 under independent review, but is not a final-hash semantic pass. Fresh 4.8.1 installed-path checks admitted 10/10 calls; independent review scored Codex 5/5 and Claude 1/5 on the selected affected cases. Claude still sometimes makes unsupported claims, leaves defective constructions, omits the personal strict lint run, or adds unrequested explanation. See `validation-results.md`, `acceptance-deviation.md`, and `validation/installed-4.8.1.md` for exact cases. The user explicitly accepted release with these failures documented. The CLI tests used explicit installed-file paths and do not prove automatic discovery by skill name.

## Recovery

Raw provider prompts, outputs, and event traces remain local and ignored under `validation/raw/`; curated evidence is tracked in the run. The old untracked canonical run was preserved at `/tmp/agent-skills-canonical-run-pre-merge-20260914` before the canonical sync. Continue from v1.6.1 for any behavioral follow-up, using the documented fixtures and current installed hashes. Do not treat model-output failures as test passes.
