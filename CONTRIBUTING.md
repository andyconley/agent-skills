# Contributing

`agent-skills` is a small maintainer-led repository for portable writing skills. Contributions are welcome when they keep the skills host-agnostic, installable through one script, and strict about output quality.

## Before You Start

Open an issue before large behavior changes, new skills, installer changes, CI changes, or changes to the shared output discipline. Small documentation fixes, test fixtures, and narrow bug fixes can go straight to a pull request.

Good contributions explain:

- the problem being solved
- which skill or repo surface changes
- why the change belongs in the shared skill instead of local instruction
- how the behavior was validated

## Local Setup

Clone the repo, then install the skills from the checkout:

```bash
git clone https://github.com/andyconley/agent-skills.git
cd agent-skills
./install.sh --all
```

The installer links selected skills into both default runtime locations:

- Codex: `~/.agents/skills/<skill>`
- Claude Code: `~/.claude/skills/<skill>`

Start a new Codex or Claude Code session after installation so the host reloads skill discovery.

## Validation

Run the checks that match the change.

For most repo changes:

```bash
./scripts/validate-skills.sh
./tests/install-test.sh
git diff --check
```

For prose, examples, shared writing rules, or skill instructions:

```bash
./scripts/lint-prose.sh
```

Vale is optional for local use. Install it with the installer or your package manager:

```bash
./install.sh --all --with-vale
```

If Vale is not available, apply the final gates and pattern classes manually.

For behavior checks after editing `humanizer`, `doc-flow-review`, or shared QA files, run the prompts in:

- `examples/agent-output-regression-prompts.md`
- `tests/manual/`
- `examples/regression/`

These are regression checks for known failure modes. They are not an objective scoring system.

## Pull Requests

Keep pull requests focused. Include validation evidence in the PR body, and call out anything that affects install, uninstall, strict mode, Vale, runtime metadata, or host-agnostic behavior.

Use Conventional Commits for commit messages, for example:

```text
docs: clarify unattended install examples
fix: reject malformed skill versions
feat(humanizer): add term-drift guidance
```

## Adding or Retiring Skills

Add a skill by creating `skills/<slug>/SKILL.md`, adding `skills/<slug>/VERSION`, and declaring the skill in `skills/manifest.tsv`.

To retire a skill, move its declaration from `skills/manifest.tsv` to `skills/retired.tsv` and leave the source directory in place. Existing symlinks keep working, and new installs no longer list the skill.

## Security

Do not open public issues with vulnerability details. Follow [SECURITY.md](SECURITY.md) instead.
