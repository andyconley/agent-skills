# Agent Skills

Portable skills for Codex, Claude Code, and other LLM agents. The repository includes writing skills and a guarded work-breakdown workflow for Jira milestone planning.

These skills exist because most agent writing problems are not vocabulary problems. The usual failure is shape: the answer starts too low, explains the method, mirrors its own rhythm, preserves weak headings, or rewrites prose before the document has earned its structure.

The repo's strategy is to make those failures explicit and testable. Skill behavior lives in Markdown instructions, shared rules, examples, regression fixtures, and optional Vale checks. Host-specific metadata stays thin so the same skill can move across runtimes.

For the deeper strategy, theory, and repo map, see [docs/README.md](docs/README.md).

## Skills

| Skill | Use it for | Do not use it for |
| --- | --- | --- |
| `doc-flow-review` | Structure, information order, progressive disclosure, argument, and depth | Copyediting, fact-checking, or rewriting prose |
| `humanizer` | Engineering rewrites, personal edits, and pattern audits | Structural review or changing protected requirements |
| `workbreakdown` | Direct Epic-child work, concise versioned Jira descriptions, YAML manifests, hard dependencies, and Jira reconciliation | Portfolio hierarchy or unreviewed Jira changes |

When a document needs both, run `doc-flow-review` first. Apply the structural decisions, then run `humanizer` on the prose.

All skills are host-agnostic. The optional `agents/openai.yaml` files provide Codex UI metadata, but the behavior lives in Markdown skill files and references that Claude Code and other hosts can read.

Both writing skills check construction patterns in normal mode. Humanizer engineering edits and doc-flow-review output retain the shared discipline. Personal humanizer edits diagnose those patterns under the local policy; a match alone does not justify changing effective source prose.

Both writing skills support optional strict mode. Trigger it with wording such as `strict`, `high`, `hard pass`, `vale pass`, or `lint pass`. Strict mode applies the selected policy and uses applicable Vale checks when available. Missing tools are reported accurately. Personal lint findings are advisory; they do not override source voice or prove factual accuracy.

## Humanizer requests

Engineering is the default. Personal mode requires an explicit request; document genre or a request to make text natural does not select it.

```text
Use humanizer to rewrite this engineering proposal.
Use humanizer personal mode. Keep my voice and make minimal edits.
Use humanizer to audit this draft without rewriting it.
Use humanizer personal mode with strict validation.
```

Audit follows the selected mode and defaults to engineering, including for journal entries. It identifies source spans, reader problems, and repair directions. It does not infer authorship or return a replacement draft.

Personal mode preserves useful humor, cadence, admissions, and digressions already in the draft. It does not invent personality or require a separate voice sample. An actual procedure or reference section retains engineering discipline across the document. A command quoted in a personal story does not change the story's mode; the command remains exact.

Humanizer loads [its local policy](skills/humanizer/references/policy.md) for each edit or audit. Shared agent commentary and doc-flow-review keep their existing rules.

Humanizer 4.8 is a best-effort writing aid. In source-verified candidate tests, Claude sometimes omitted a required personal lint check, missed excessive bold formatting, retained mirrored engineering prose, or lost a numeric threshold, an unknown rollback duration, or the distinction between `job` and `task`. An earlier Codex candidate dropped a source expectation and the `config` target from an operational step; both were retained in a focused retake after the policy fix. Review consequential edits against the source, especially procedures and requirements. The [validation record](.flow/runs/20260911-humanizer-modes/validation-results.md) gives the cases and observed results.

## Simplified Technical English

The writing discipline is STE-inspired: short sentences, active voice, one term for one thing, plain verbs, no idioms, and no deleted caveats.

Reference documents, checklists, and procedures take a stricter set of word-choice rules drawn from ASD-STE100: one term per thing, plain verbs instead of phrasal verbs, no idioms, and numbers instead of adjectives. The same rules govern the agent's own replies through `shared/agent-output-discipline.md`.

An operational or reference document takes these rules as a whole. If any section is reference, checklist, or procedure, the rules apply everywhere in it and the conversational moves are dropped, so a reader working through a procedure never switches registers.

These skills implement applicable rules. They do not include the approved-word dictionary, which is the substance of ASD-STE100 and is licensed. Do not describe their output as STE-conformant.

## Install

macOS and Linux are supported. The installer keeps a checkout at `${AGENT_SKILLS_HOME:-$HOME/agent-skills}` and links selected skills into both Codex and Claude Code. It never removes skills it does not manage.

```bash
curl -fsSL https://raw.githubusercontent.com/andyconley/agent-skills/main/install.sh | bash
```

The interactive installer lists the manifest and lets you choose one, several, or all skills. Empty input cancels without making changes.

For unattended installation from the remote installer:

```bash
curl -fsSL https://raw.githubusercontent.com/andyconley/agent-skills/main/install.sh | bash -s -- --all
```

From a local checkout, you can install selected skills:

```bash
./install.sh --skill humanizer --skill doc-flow-review
./install.sh --skill workbreakdown
```

Vale is optional, but enables strict-mode prose linting. If Vale is missing, interactive installs offer to install it. For unattended installs from a local checkout:

```bash
./install.sh --all --with-vale
./install.sh --all --no-vale
```

`--with-vale` installs Vale with Homebrew when available and fails clearly when no supported installer is found. `--no-vale` skips dependency handling.

The default targets are:

- Codex: `~/.agents/skills/<skill>`
- Claude Code: `~/.claude/skills/<skill>`

If a selected target already contains a file, directory, or unrelated symlink, the installer stops before changing any target. Move or back up the conflict, then retry. A correct existing symlink is left in place.

## Documentation

Start with [docs/README.md](docs/README.md) for the strategy, theory, skill docs, shared writing rules, examples, tests, and tooling.

## Releases

Releases are generated from Conventional Commits on `main`. Skill behavior changes should use a scope that names the affected surface, such as `feat(humanizer):`, `fix(doc-flow-review):`, or `docs(shared):`.
Documentation-only releases should still describe the user-visible behavior, rule, or workflow that changed.

## Update

Run the installer again. It requires a clean checkout with the expected GitHub origin, updates it with a fast-forward-only pull, and refreshes the selected links. Existing links point at the updated source automatically.

## Uninstall

Uninstall removes only symlinks that point to this checkout. It does not delete skill source, the checkout, or unrelated runtime skills.

```bash
./install.sh --uninstall --skill humanizer
./install.sh --uninstall --all
```

Start a new agent session afterward. A built-in skill resumes only if the host provides one with the same name.

## Use with another LLM

Give the model the relevant `SKILL.md` as task instructions. Include referenced supporting files when needed.

The shared output discipline lives in `shared/agent-output-discipline.md`. Final gates live in `shared/final-gates.md`; pattern classes live in `shared/pattern-classes.md`. The examples in `examples/` show bad and good agent output, plus manual regression prompts for checking whether an agent is getting wordy, using polished review-template headings, or preserving mirrored rhythm.

`doc-flow-review` uses `assets/reviewer-block.md` only when generating a reviewer-request block. `workbreakdown` preserves immutable v1/v2 templates and uses concise template-set-3 defaults under `assets/jira-templates/`. Manifest schema 2 remains child-only. Schema 3 adds explicit, drift-checked authority for an approved Epic description update. Story plans name contextual documentation, mapped integration or functional tests, and the smallest instrumentation set that proves the Story outcome or an operational decision. Current evidence for all three gates entry to `IN REVIEW`, not the start of implementation.

The default skill behavior needs no scripts, network access, connectors, or product-specific tools. Strict mode can optionally use the Vale wrapper when available. Optional `agents/openai.yaml` files add Codex UI metadata; other hosts can ignore them.

## Skill versions

Each skill ships a semantic version in `skills/<slug>/VERSION`. The same version appears in the skill description and body so an agent can report what it loaded. Validation rejects missing, malformed, or inconsistent versions.

Ask the active agent directly—for example, “What version of humanizer are you using?” A session opened before an update may still report the version it loaded. Start a new session to verify an upgrade.

## Add a skill

Add `skills/<slug>/SKILL.md`, make its frontmatter `name` match the directory, add a semantic `VERSION`, and declare it in `skills/manifest.tsv` as `slug<TAB>description`. Repeat the version in the frontmatter description as `Version X.Y.Z.` and in the body as `**Version: X.Y.Z.**`. CI rejects duplicates, missing directories, undeclared directories, name mismatches, and version drift.

To retire a skill, move its declaration from `skills/manifest.tsv` to `skills/retired.tsv` and leave its source directory in place. It disappears from new installs, existing symlinks keep working, and no runtime target is pruned.

## Development

```bash
./scripts/validate-skills.sh
./tests/install-test.sh
./tests/lint-prose-test.sh
python3 tests/humanizer-fixture-test.py
```

For behavior checks after editing the writing skills, run the prompts in `examples/agent-output-regression-prompts.md` against the target agent. These are manual checks, not an objective scoring system.

For a fuller pass, use:

- `examples/regression/` for bad source/output, failure reason, expected shape, and pass checks
- `tests/manual/` for prompts to run against a live agent

For mechanical prose linting, install Vale through the installer or your package manager, then run:

```bash
./scripts/lint-prose.sh
./scripts/lint-prose.sh --profile engineering -- path/to/draft.md
./scripts/lint-prose.sh --profile personal -- path/to/pasted-text.txt
```

The Vale profiles live in `tools/vale/`. CI and local checks use the same repository profile. Governing documentation stays under engineering lint; intentional fixture data has separate behavioral checks. Personal diagnostics are advisory, while invalid requests and tool failures still fail the command. Use `--help` for the supported interface; pass artifact profiles explicitly when checking a draft.

## License

[MIT](LICENSE)

## References

- [Agent Skills open standard](https://agentskills.io)
- [Claude Code skills](https://code.claude.com/docs/en/skills)
- [OpenAI skill guidance](https://learn.chatgpt.com/docs/build-skills)
