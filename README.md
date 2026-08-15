# Agent Skills

Portable skills for Codex, Claude Code, and other LLM agents. The first two separate document structure from prose cleanup and share a short-output discipline:

| Skill | Use it for | Do not use it for |
| --- | --- | --- |
| `doc-flow-review` | Structure, information order, progressive disclosure, argument, and depth | Copyediting, fact-checking, or rewriting prose |
| `humanizer` | Direct, concise prose in an experienced engineering-leader voice | Structural review or changing protected requirements |

When a document needs both, run `doc-flow-review` first. Apply the structural decisions, then run `humanizer` on the prose.

Both skills are intentionally host-agnostic. The optional `agents/openai.yaml` files provide Codex UI metadata, but the actual behavior lives in Markdown skill files and shared examples.

Both writing skills run the shared construction sweep in normal mode. The sweep removes mirrored rhythm, stance headings, aphoristic closers, signpost nominalization, decorative contrast, and similar agent-shaped prose from the skill output.

Both writing skills support optional strict mode. Trigger it with wording such as `strict`, `high`, `hard pass`, `vale pass`, or `lint pass`. Strict mode runs Vale when shell access exists and Vale is installed, then falls back to the shared final gates and pattern classes when it cannot run.

The writing discipline is STE-inspired: short sentences, active voice, one term for one thing, plain verbs, no idioms, and no deleted caveats. It does not claim full ASD-STE100 compliance or dictionary enforcement.

## Install

macOS and Linux are supported. The installer keeps a checkout at `${AGENT_SKILLS_HOME:-$HOME/agent-skills}` and links selected skills into both Codex and Claude Code. It never removes skills it does not manage.

```bash
curl -fsSL https://raw.githubusercontent.com/andyconley/agent-skills/main/install.sh | bash
```

The interactive installer lists the manifest and lets you choose one, several, or all skills. Empty input cancels without making changes.

For unattended installation:

```bash
curl -fsSL https://raw.githubusercontent.com/andyconley/agent-skills/main/install.sh | bash -s -- --all
./install.sh --skill humanizer --skill doc-flow-review
```

Vale is optional, but enables strict-mode prose linting. If Vale is missing, interactive installs offer to install it. For unattended installs:

```bash
./install.sh --all --with-vale
./install.sh --all --no-vale
```

`--with-vale` installs Vale with Homebrew when available and fails clearly when no supported installer is found. `--no-vale` skips dependency handling.

The default targets are:

- Codex: `~/.agents/skills/<skill>`
- Claude Code: `~/.claude/skills/<skill>`

If a selected target already contains a file, directory, or unrelated symlink, the installer stops before changing any target. Move or back up the conflict, then retry. A correct existing symlink is left in place.

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

`doc-flow-review` uses `assets/reviewer-block.md` only when generating a reviewer-request block.

The default skill behavior needs no scripts, network access, connectors, or product-specific tools. Strict mode can optionally use the Vale wrapper when available. Optional `agents/openai.yaml` files add Codex UI metadata; other hosts can ignore them.

## Skill versions

Each skill ships a semantic version in `skills/<slug>/VERSION`. The same version appears in the skill description and body so an agent can report what it loaded. Validation rejects missing, malformed, or inconsistent versions.

Ask the active agent directly—for example, “What version of humanizer are you using?” A session opened before an update may still report the version it loaded. Start a new session to verify an upgrade.

## Add a skill

Add `skills/<slug>/SKILL.md`, make its frontmatter `name` match the folder, add a semantic `VERSION`, and declare it in `skills/manifest.tsv` as `slug<TAB>description`. Repeat the version in the frontmatter description as `Version X.Y.Z.` and in the body as `**Version: X.Y.Z.**`. CI rejects duplicates, missing directories, undeclared directories, name mismatches, and version drift.

To retire a skill, move its declaration from `skills/manifest.tsv` to `skills/retired.tsv` and leave its source directory in place. It disappears from new installs, existing symlinks keep working, and no runtime target is pruned.

## Development

```bash
./scripts/validate-skills.sh
./tests/install-test.sh
```

For behavior checks after editing the writing skills, run the prompts in `examples/agent-output-regression-prompts.md` against the target agent. These are manual checks, not an objective scoring system.

For a fuller pass, use:

- `examples/regression/` for bad source/output, failure reason, expected shape, and pass checks
- `tests/manual/` for prompts to run against a live agent

For mechanical prose linting, install Vale through the installer or your package manager, then run:

```bash
./scripts/lint-prose.sh
./scripts/lint-prose.sh path/to/draft.md
./scripts/lint-prose.sh path/to/pasted-text.txt
```

The repo-local Vale config lives in `tools/vale/`. CI runs the same rules against the repo's Markdown docs and fixtures.

## License

[MIT](LICENSE)

## References

- [Agent Skills open standard](https://agentskills.io)
- [Claude Code skills](https://code.claude.com/docs/en/skills)
- [OpenAI skill guidance](https://learn.chatgpt.com/docs/build-skills)
