# Validation Results

## Automated checks

Passed on 2026-09-08. Re-run after review follow-up on the same date; see the amendment at the end of this file.

- `bash -n install.sh scripts/*.sh tests/*.sh tests/workbreakdown/*.sh`
- `./scripts/validate-skills.sh` — 3 skills validated
- `./tests/workbreakdown-contract-test.sh` — parsed v2 fixtures and contract checks passed
- `./tests/install-test.sh` — 17/17 installer cases passed
- `./scripts/lint-prose.sh` — 0 errors, warnings, or suggestions across 45 files
- `quick_validate.py skills/workbreakdown` — skill valid
- `git diff --check`

V1 template hashes match the pre-change assets:

- Epic: `e6ac1fced57839ccaca7c56fe42cd08b5907af5b15f2f050625350dfaf9c758a`
- Story: `b8865258f0a17dd5f495e4b004fa27761af0b89911be405f5f1f6fc2602b3259`
- Task: `b7bd307184299f026c25df32903455f0ee6fa60d66e6f08ef747508685adffe6`
- Spike: `66dcbb09cbface7f0ceadd8feddb25e2512d4e488f3d414427ba2e7393b3eb88`

## Mutation check

Ran. The registered Epic v1 hash was changed deliberately. `workbreakdown-v2-test.sh` failed with `FAIL: hash drift for jira-epic-v1`. The correct hash was restored and the full suite passed.

## Review

- Quality review: PASS after all findings were corrected.
- Architecture boundary review: PASS after all findings were corrected.
- Validation ran against the changed registry, templates, contracts, fixtures, installer assertions, and documentation—not a surrogate checkout.

## Manual and external checks

- Fresh Codex and Claude Code behavior prompts: not run. Static package and two-host installation-link coverage passed.
- Live Jira Apply: not run. No isolated Jira mutation was authorized for this implementation.
- Jira and Confluence mutation: none.
- Local install refresh: passed from the clean checkout. Both `/Users/andyconley/.agents/skills/workbreakdown` and `/Users/andyconley/.claude/skills/workbreakdown` report 1.2.0.

## Amendment after acceptance review

The record above describes the tree at commit `4324cc5`. Two later changes altered it.

- `tests/workbreakdown/workbreakdown-v2-test.rb` gained an explicit UTF-8 external encoding (repository v1.3.1). The suite had depended on the ambient locale and failed under `LC_ALL=C`.
- Review follow-up changed the Spike v2 templates, the registry hashes for both, four references, the fixture suite, and CI. See `review.md`.

Re-verified after those changes, in both the default locale and `LC_ALL=C`:

- `bash -n install.sh scripts/*.sh tests/*.sh tests/workbreakdown/*.sh`
- `./scripts/validate-skills.sh` — 3 skills validated
- `./tests/workbreakdown-contract-test.sh` — passed in both locales
- `./tests/install-test.sh` — 17/17 in both locales
- Vale — 0 findings across 45 files
- `git diff --check`

V1 template hashes are unchanged from the values recorded above and remain byte-identical to the pre-change assets at tag `v1.2.0`. The Spike v2 hashes changed by design and are recorded in the registry.

Mutation check on the new render-target assertion: removing `## Downstream updates` from `spike-design-v2.md`, with all three hash sites realigned so the drift check could not mask it, produced `FAIL: jira-spike-design-v2 requires downstream_updates but the shipped template cannot render it`. Restoring the section returned the suite to green.
