# Vale Support

This directory contains optional Vale configuration for the writing skills.

Vale is the mechanical tripwire layer. It catches stable surface tells such as polished headings, author-state narration, stance phrases, mirrored rhythm, aphoristic closers, weak STE discipline, and review-template wording. It does not replace the skills' final gates or pattern-class judgment.

## Install Vale

Install Vale with your preferred package manager or from the official releases.

Examples:

```bash
brew install vale
```

```bash
go install github.com/vale-cli/vale/v3/cmd/vale@latest
```

## Run

From the repo root:

```bash
./scripts/lint-prose.sh --profile repository
```

To lint explicit engineering or personal-writing targets:

```bash
./scripts/lint-prose.sh --profile engineering -- path/to/draft.md
./scripts/lint-prose.sh --profile personal -- path/to/pasted-text.txt
```

A bare target uses the engineering profile to support existing strict skill
callers. New callers should select a profile explicitly.

The repository and engineering profiles use the full technical-writing
tripwires. The personal profile selects `CorporateFiller` as an advisory
signal only. A personal finding is a prompt for editorial judgment, not a
requirement to remove source voice. Vale never selects an editing mode or
determines whether a draft is operational; humanizer does that work.

## Rule Levels

- `error`: stable tells that should block repo QA.
- `warning`: useful tripwires that can be noisy in legitimate prose.
- `suggestion`: house-style preferences that depend on your vocabulary.

CI fails on errors only. Warnings and suggestions report without blocking.

## Word-choice rules

`PlainVerbs` and `TermDrift` come from the Simplified Technical English rules in the writing skills. Both use Vale's `substitution` check, which applies word boundaries by default. `turn on` does not match `turn one problem`.

`PlainVerbs` swaps phrasal verbs for plain ones: `turn off` becomes `disable`, `set up` becomes `configure`. It runs at `warning` because a phrasal verb is sometimes the honest choice in quoted material.

`TermDrift` enforces one name per thing. The list that ships here is a starter set covering the compound and spelling variants that drift in most technical writing. **Replace it with your own vocabulary.** The pairs that matter are the ones your codebase and your docs disagree about, and no shipped list can guess them. It runs at `suggestion` for that reason.

Strict mode in the skills should run Vale when available and fall back to manual final gates and pattern classes when it is not.
