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
./scripts/lint-prose.sh
```

To lint specific files or directories:

```bash
./scripts/lint-prose.sh path/to/draft.md
./scripts/lint-prose.sh path/to/pasted-text.txt
./scripts/lint-prose.sh examples/regression/
```

## Rule Levels

- `error`: stable tells that should block repo QA.
- `warning`: useful tripwires that can be noisy in legitimate prose.

Strict mode in the skills should run Vale when available and fall back to manual final gates and pattern classes when it is not.
