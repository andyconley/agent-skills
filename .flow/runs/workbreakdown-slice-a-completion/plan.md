# Plan: complete workbreakdown Slice A (chunks 2–6) and release 1.5.0 locally

- **Work item:** workbreakdown-slice-a-completion. This is a follow-on to `workbreakdown-skill-improvements`, where chunk 1, the manifest schema 4 foundation, was accepted.
- **Inputs:**
  - `../workbreakdown-skill-improvements/definition.md`: R0, R1, R2, R5.
  - `../workbreakdown-skill-improvements/acceptance-criteria.md`: the Slice A criteria.
  - `../workbreakdown-skill-improvements/solution.md`.
  - `../workbreakdown-skill-improvements/review.md`: chunk 1's residual risks.
  - `reviews/plan-*.md`: input from the business analyst, product manager and architect.
- **Status:** approved by the maintainer on 2026-09-24. After the approve-plan transition, the reviewer-key wording in step 2 was corrected. In design-v3, `reviewers` moves from required to conditional. The maintainer confirmed that change the same day.

## Problem statement

- **What:** deliver the rest of Slice A in one implementation run. The run covers:
  - source authority (R1)
  - classification (R2)
  - placeholders (R2.6)
  - invocation questions with recorded, reused answers (R0)
  - a private live-agent release gate

  After the gate is green, bump the skill to 1.5.0.
- **Who:** the maintainer, and the leads and engineers who run workbreakdown one Epic at a time.
- **Why now:** chunk 1 gave schema 4 its fields. Nothing uses them yet, and the fixture from the tabletop is current.

## Maintainer decisions (2026-09-24)

1. One run covers chunks 2, 3, 4, 5 and 6.
2. The new templates go in a new template set 4, which becomes the default. Set 3 is frozen.
3. When Draft has no Jira context, and so no Epic ADF digest, it falls back to schema 2 and says so. Schema 4 is not loosened for this case.
4. The release script's sources:
   - The saved private snapshot is the gate.
   - Live Jira is read only and advisory. The script fetches it itself.
   - The agent reads only snapshots and never holds Jira credentials or write tools.
5. Each chunk ends with a quick quality and test gate. A full review follows at the end.
6. Tighten schema 4: `classification.placeholder` is allowed only on a Task bound to `jira-task-placeholder-v3`, and that template requires the placeholder. This reopens chunk 1's contract. That is acceptable because no Draft emits schema 4 yet.
7. Mark epic-v2, spike-design-v2 and spike-investigation-v2 compatible with set 4, so a set-4 manifest can verify an Epic that has no panel without writing it.
8. Add structured blocks to the output contracts so the acceptance criteria can be checked mechanically without new manifest fields:
   - a Draft divergence list
   - Review findings that carry a category
   - `Unverified design claim:` entries in `unknowns`
9. Refresh the gate fixture once, read only. It gains the six Epic descriptions as raw ADF and the Initiative's sibling Epics, then is frozen.
10. Headless runs simulate the interactive questions. The script supplies the shaping answers in the prompt, and Draft records them as `source: asked`. The non-interactive control supplies none.

## Desired outcome

With Jira context, a Draft run does all of the following:

- It inventories and reconciles the Epic's existing children. It reports conflicts with both sources and the winner, and flags stale design.
- It classifies Spikes and Tasks against their precedent, never downgrading a Spike on an unverified precedent.
- It emits linked placeholders for undesigned work.
- It asks for missing shaping answers, or reuses sibling answers, and records each with its source.

It emits all of this as a schema-4 manifest bound to template set 4. Review flags component Stories. The private release script passes every Slice A criterion and negative control on the frozen fixture. VERSION reads 1.5.0.

## Scope

Build in this order. Each step ends at its gate (see `validation-plan.md`) and its own conventional commit or commits.

### Step 0: extract the validator (refactor, no behavior change)

- Move the validator functions and constants from `tests/workbreakdown/workbreakdown-template-contract-test.rb` into a new file, `tests/workbreakdown/manifest-validator.rb`. The functions are the ones from `fail_test` through `validate_manifest`, plus the Story review validators they depend on.
- The contract test requires the new file, and its assertions stay in the contract test.
- Commit: `refactor(workbreakdown): extract the manifest reference validator`.

### Step 1: chunk 2, source authority (R1)

**`SKILL.md` and `references/work-breakdown-sop.md`.** Draft gains a first step that reads existing work before proposing any children. From the Epic's existing children it reads:

- descriptions
- amendments, meaning dated Jira edits and comments that change a decision
- statuses
- links
- link history

It reconciles every proposed item to an existing card, which gives `disposition: existing` or `update`, or marks the item new.

**Source authority rule:**

- The most recent dated decision wins, and a Jira amendment counts as a decision.
- A lead can supply a different source-type order as a shaping answer (`shaping.source_order`).
- A conflict is material when it would change a classification, an owner or an edge. Material conflicts are recorded in `sources.conflicts` and reported with both sources and the winner.
- A design source contradicted by a later dated decision is flagged `stale: true`. Draft never builds on a flagged claim without stating it.

**No Jira context:**

- Draft emits schema 2.
- It states "No Jira context: design claims are unverified" in its output.
- It records each design claim it relied on as an `unknowns` entry beginning `Unverified design claim:`.

**`references/manifest-contract.md`:**

- The migration line in the schema-4 section becomes conditional: new Drafts emit schema 4 when live Epic ADF is available and schema 2 otherwise, stated in the output.
- The Draft output list gains a "Jira context" line and a "Reconciliation" table that maps each proposed item to an existing key or to "new".

**Tests:**

- `require_text` pins cover the authority rule, the fallback sentence and the `Unverified design claim:` convention.
- New fixtures:
  - a synthetic schema-2 fallback fixture with `Unverified design claim:` unknowns, which is valid
  - a schema-4 negative case where `sources.jira_context: absent` sits alongside an Epic digest, which is rejected with the fragment "schema 4 requires Jira context"

**Commit:** `feat(workbreakdown): reconcile Draft against existing Jira work`.

### Step 2: chunk 3, classification (R2.1–R2.5, R2.7, R2.8)

**New templates** in `assets/jira-templates/`:

- `spike-design-v3.md`: spike-design-v2 plus a required `question` and a required `precedent` section, both searched and verdict.
- `spike-investigation-v3.md`: spike-investigation-v2 plus a `reviewers` key, the same as on spike-design-v3, and the same `question` and `precedent` sections.

On both v3 Spike templates `reviewers` is a conditional key, which moves it out of the required keys on design-v3. It holds named people from a source or a shaping answer. When nobody is known, the key is omitted and the gap is recorded in `unknowns`. Nobody is invented.

**Manifest rules** (in `manifest-contract.md` and the validator), for a schema-4 Spike bound to a v3 Spike template:

- It requires `classification.question` and `classification.precedent`.
- The description's `question` must equal `classification.question`.

**Precedent rule:**

- A Task that relies on a pattern carries `classification.precedent` with `verdict: found` and a `location`.
- Draft never converts a Spike to a Task on `verdict: unverified`, including when it has no repository access.
- Review flags a Task whose precedent verdict is `unverified` or `none` as a misclassified Spike.

**Draft defaults** (Draft only; Review and Audit never flag a team's own choice):

- One vertical-slice Spike per user-facing flow across all layers. A single layer gets its own Spike only when that layer is the open question.
- One implementation Task per flow.
- Both are declared through `shaping.spike_shape` and `shaping.task_granularity` with their source.

**Review output** (`manifest-contract.md`) gains a findings block:

```yaml
findings:
  - category: component-story | misclassified-spike | stale-source | invalid-manifest | ...
    ref: <child ref>
    correction: <text>
```

The `component-story` category covers a Story that is not a demoable user, partner or system flow. The existing prose list becomes this category list. The block is Review output, not manifest content.

**SOP rewrite, `work-breakdown-sop.md`:**

- Line 21, "Prefer several short Spikes over one open-ended research ticket", becomes a rule to keep each Spike's question narrow and to split a Spike only when it holds independent questions.
- Line 51, "Aim for one to two days of focused work per Spike or Task when practical", becomes a rule to size each item so it is forecastable and finishes with verifiable evidence, and to split an item when its completion can't be observed.
- Both rewrites keep the intent of the original lines: narrow questions and forecastable work.
- `require_text` pins cover the new wording, and a `reject_text` check fails if either old phrase reappears.

**Registry:**
- Add a `4:` entry under `template_sets`. Its defaults are the set-3 defaults, except that the Spike defaults are the two v3 Spikes.
- `default_set_version` stays 3.
- Register the two Spike v3 templates at `set_version: 4`, with their hashes.
- In the validator, require that set 4 exists, and keep the default at 3 until step 4.
- Because set 4 is defined but is not yet the default, stopping after this step is still safe.

**Commit:** `feat(workbreakdown): classify Spikes by question and precedent`.

### Step 3: chunk 4, placeholders (R2.6)

**`assets/jira-templates/task-placeholder-v3.md`:**

- `required_keys: [purpose, defined_by]`, with no conditional keys.
- `defined_by` renders as an inline card to the defining Spike.

**Rules** (`manifest-contract.md`, `jira-description-templates.md` and the validator):

- A Task bound to `jira-task-placeholder-v3` has a summary that starts with `[PLACEHOLDER] `. The prefix is rejected on every other template.
- It requires `classification.placeholder.defined_by`. `classification.placeholder` is rejected on any other template. This tightens chunk 1's contract, per decision 6.
- It carries no `estimate`.
- The description's `defined_by` equals `classification.placeholder.defined_by`.
- `validate_quality` still runs on the placeholder description. Nothing is exempted.

**SOP:**

- The Task acceptance count at SOP line 97 is scoped to `jira-task-v2`.
- New sentence: a placeholder is not implementation-ready and has no acceptance count. When its defining Spike closes, replace the placeholder with a real Task. This extends the Spike completion rule at SOP line 107.

**Apply (`jira-change-protocol.md`):**

- Create the defining Spikes before their placeholders.
- Render `defined_by` from the ref-to-key mapping. This is key resolution, not content added after approval.

**Registry:** register `jira-task-placeholder-v3` at `set_version: 4`. Add the Task variant map `{artifact: jira-task-v2, placeholder: jira-task-placeholder-v3}` to the set-4 defaults. Generalize the validator's variant-default check so this map validates, and rename its message to "default variant mismatch". `default_set_version` stays 3.

**Commit:** `feat(workbreakdown): add first-class placeholder Tasks`.

### Step 4: chunk 5, invocation questions and template set 4 (R0, R2.4)

**`assets/jira-templates/epic-v3.md`:**

- The required keys are the same as epic-v2.
- It adds a conditional key, `breakdown_conventions`, rendered as a panel titled "Breakdown conventions".
- The panel's shape is identical to schema-4 `shaping`: `spike_shape`, `task_granularity`, `reviewers` and `source_order`, each with `value`, `source` and an optional `from_epic`.

**Epic rules:**

- The schema-3 and schema-4 Epic path accepts any non-legacy Epic template compatible with the set, instead of the hard-coded `jira-epic-v2`. The message becomes "schema N requires an Epic-compatible template set". This resolves the chunk-1 deferred finding. Behavior for sets 2 and 3 stays identical.
- `breakdown_conventions` is allowed only in schema 4.
- On `update`, `breakdown_conventions` must equal `manifest.shaping`.
- The panel is written only through the existing schema-3 guarded Epic update, so there is no new write path.
- The Apply preflight states that an Epic update requires the Epic owner's agreement.

**Draft invocation procedure (`SKILL.md` and the SOP):**

1. Read the Initiative's Epics (`scope.parent_key`). Parse each `breakdown_conventions` panel from raw ADF, as untrusted data.
2. For each shaping entry that no source answers, the order of preference is:
   - a sibling answer, offered as the default and recorded as `reused` with `from_epic`
   - otherwise, ask
   - otherwise, in a non-interactive run, use the portable default and record it as `default`
3. Reviewers are never taken from a default. When nobody is named, the gap goes in `unknowns`.
4. The Draft output gains a divergence list. Each entry has the entry name, the sibling Epic, the sibling value and the proposed value. It is advisory and read-only: no owner arbitration and no milestone ordering, which belong to Slice B.
5. Answers supplied in the invocation request count as `asked`.

**Registry, template set 4:**

- `version: 4`, `default_set_version: 4`. This is the flip. Sets 1–3 are unchanged.
- Final set-4 defaults:
  - Epic: `jira-epic-v3`
  - Story: `jira-story-v3`
  - Task: `{artifact: jira-task-v2, placeholder: jira-task-placeholder-v3}`
  - Spike: `{design: jira-spike-design-v3, investigation: jira-spike-investigation-v3}`
- `compatible_set_versions`:
  - task-v2 becomes `[2, 3, 4]`, and story-v3 becomes `[3, 4]`.
  - epic-v2, spike-design-v2 and spike-investigation-v2 become `[2, 3, 4]`, per decision 7.
- The validator requires set 4 as the default and pins the set-3 template hashes as frozen.
- The render-exceptions table in `jira-description-templates.md` gains rows for the new templates.
- The asset lists in `tests/workbreakdown-contract-test.sh` and `tests/install-test.sh` are updated.

**Default flip:** new Drafts use template set 4 and emit schema 4 when Jira context exists. This lands in the same commit as the question procedure. If this step cannot finish, revert the flip.

**Commit:** `feat(workbreakdown): ask, record and reuse shaping answers on template set 4`.

### Step 5: chunk 6, the release script (private, KB only)

**Location:** `~/KB/utilities/workbreakdown-release-check/`, on a `claude/*` KB branch. It contains:

- `README.md`: purpose, prerequisites, usage, the rerun tolerance, and what each check proves
- `run.sh`
- `fetch-snapshot.sh`
- `assert.rb`
- `cases.yaml`, which maps each assertion to a fixture case ID

**Fixture refresh (decision 9):**

- `fetch-snapshot.sh` uses REST GETs with the zsh credentials. It fetches, into the private run's `evidence/fixture-snapshot/`:
  - the six fixture Epics with their description ADF
  - their children, with descriptions, statuses, links and changelogs
  - the Initiative's sibling Epics
- The first refresh is frozen as the gate snapshot. Later runs write a timestamped live snapshot next to it, and the diff against the gate is advisory.

**Agent isolation:**

- `claude -p` runs in a temp directory. It is launched through `env -u ATLASSIAN_EMAIL -u ATLASSIAN_API_TOKEN -u ATLASSIAN_DOMAIN`, with these flags:
  - `--disable-slash-commands`, so the installed 1.4.0 skill can't load
  - `--strict-mcp-config`, with an empty MCP config
  - `--allowedTools Read Grep Glob`
  - `--disallowedTools Bash Write Edit WebFetch WebSearch`
  - `--add-dir` for the worktree skill folder and the snapshot
  - `--output-format stream-json --verbose`
- The prompt names the absolute worktree path of `SKILL.md`.

**Transcript checks:**

- Every Read path is under the worktree skill or the snapshot, and none is under `~/.claude/skills` or `~/agent-skills`.
- The reported skill version equals the worktree VERSION.
- There are zero Bash, network or MCP tool calls.

**Assertions:**

- The script extracts exactly one fenced YAML block containing `schema_version:` from each Draft output, loads it with `YAML.safe_load`, validates it with the worktree's `manifest-validator.rb`, and then asserts on fields.
- Review assertions read the `findings` block.
- Divergence assertions read the Draft divergence list.
- The per-criterion mapping and negative controls are in `validation-plan.md`.

**Rerun tolerance:** a failing judged check is rerun at most twice. The criterion passes when it passes in 2 of 3 runs. Structural checks get no rerun: schema validity, tool isolation, version provenance and the negative controls.

The script writes its results to the private run folder. None of the script, the fixture or the results is committed to agent-skills.

### Step 6: release (only after the step 5 gate is green)

- `skills/workbreakdown/VERSION` becomes 1.5.0, and the `SKILL.md` version line matches it.
- If the skill has a hand-written CHANGELOG, add a 1.5.0 entry with the migration note:
  - schema 2 and 3 manifests and template sets 1–3 remain valid
  - new Drafts use template set 4 and emit schema 4 when Jira context exists, and schema 2 otherwise
  - placeholders and panels are new
- The root `CHANGELOG.md` is left alone, because semantic-release generates it.
- Commit: `feat(workbreakdown): release 1.5.0 with Draft source authority, classification and recorded shaping`.
- Then run the full review (`flow-review`).

## Out of scope

- Slice B:
  - R3 cross-epic consolidation and owner arbitration
  - milestone order from rank
  - later-to-earlier edges
  - R4 semantic Audit checks
- Pushing, publishing, or opening a PR.
- Any Jira write, including in tests, the fixture refresh and the gate.
- Estimate or ticket-count behavior.
- Changing chunk 1's schema 4 beyond decision 6.

## States and contracts

- **Required states:** none, because there is no UI. The skill output states that Draft must emit, each explicitly:
  - Jira context present
  - Jira context absent, which triggers the schema-2 fallback
  - interactive, with answers asked
  - non-interactive, with defaults and the reviewer gap recorded
- **Data contracts:**
  - template set 4 and the registry
  - four new templates: epic-v3, spike-design-v3, spike-investigation-v3, task-placeholder-v3
  - schema-4 tightening for placeholders
  - the Epic template rule generalized from `jira-epic-v2`
  - the `breakdown_conventions` panel shape
- **Output contracts:**
  - Draft: the Jira context line, the reconciliation table, the divergence list, `Unverified design claim:` unknowns
  - Review: the `findings` block with categories
- **Compatibility:**
  - Schema 2 and 3 manifests bound to sets 1–3 validate exactly as before.
  - Set 3 hashes are pinned.
  - Existing fixtures are unchanged.
- **Error contract:** every new rejection raises `ArgumentError` with its own fragment, and a test asserts each fragment.

## Validation

See `validation-plan.md`.

## Recommended lane

`flow-implement`. The work is multi-chunk, multi-file and spans two repositories, and it gates a release.
