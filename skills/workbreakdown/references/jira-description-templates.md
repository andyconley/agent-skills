# Jira Description Templates

The registry at `assets/jira-templates/registry.yaml` is the source of truth for template identity, version, issue type, variant, required keys, conditional keys, and asset hash.

Read [ticket-quality-and-completion.md](ticket-quality-and-completion.md) before drafting or reviewing any description. Its content rules apply to every template set.

## Selection

New Drafts use template-set version 3 and the registry defaults:

- Epic: `jira-epic-v2`
- Story: `jira-story-v3`
- Task: `jira-task-v2`
- design Spike: `jira-spike-design-v2`
- investigation or feasibility Spike: `jira-spike-investigation-v2`

Choose the Spike variant from its completion state. A design Spike produces a reviewed design decision and linked artifact. An investigation Spike answers a research or feasibility question. Do not force investigation work through design fields.

An approved manifest explicitly bound to an older template set stays on its selected asset. Never migrate or reformat it silently. A project-supplied template wins only when its identity, version, and content are available for review.

## Population

Every proposed issue names its `template_id` and includes its complete required description content in the manifest.

- Fill required keys with specific, actionable content.
- Include a conditional key only when it changes implementation, sequencing, acceptance, operations, or support.
- Omit unused conditional sections. Do not render empty headings or placeholder rows.
- Use `N/A` only when an immutable table shape requires a cell.
- Do not invent owners, locations, environments, evidence, constraints, or acceptance criteria.

For Story documentation, render the owner only when known. Do not leave an empty owner cell. Documentation, automated-test, and instrumentation obligations may each use a complete approved exception instead of a plan; never render both for the same obligation.

Existing issues do not need reformatting because a newer template exists. Change a description only when the approved manifest supplies an exact template ID, asset hash, and complete authorized content under `changes`.

When an older Story template cannot render the current lifecycle evidence, Review or Audit may use the separate record defined under `Legacy Story evidence` in [ticket-quality-and-completion.md](ticket-quality-and-completion.md). Do not insert v3 keys into an older bound description.

## Key rendering

A description key renders into the template section whose heading is the key name in sentence case, with underscores replaced by spaces. `milestone_outcome` renders under `## Milestone outcome`, `done_when` under `## Done when`.

These keys do not follow that rule. Render them exactly here:

| Template | Key | Renders as |
| --- | --- | --- |
| Epic v2 | out_of_scope | `**Out:**` bullet under `## Scope` |
| Epic v2 | release_quality_additions | `**Additions:**` bullet under `## Release quality` |
| Epic v2 | approved_exceptions | `**Approved exceptions:**` bullet under `## Release quality` |
| Story v2 | scenarios | `## Acceptance scenarios` |
| Story v2 | documentation | `### Documentation` under `## Delivery evidence plan` |
| Story v2 | automated_tests | `### Automated tests` under `## Delivery evidence plan` |
| Story v2 | documentation_exception | `### Documentation exception` under `## Delivery evidence plan` |
| Story v2 | automated_tests_exception | `### Automated-test exception` under `## Delivery evidence plan` |
| Story v2 | nonfunctional_requirements | `## Non-functional requirements` |
| Story v2 | review_evidence | `## Review evidence`, with its `documentation` and `automated_tests` entries as the matching bullets |
| Story v2 | supplemental_demonstration | `**Supplemental demonstration:**` bullet under `## Review evidence` |
| Story v3 | scenarios | `## Acceptance scenarios` |
| Story v3 | documentation | `### Documentation` under `## Delivery evidence plan` |
| Story v3 | automated_tests | `### Automated tests` under `## Delivery evidence plan` |
| Story v3 | instrumentation | `### Instrumentation` under `## Delivery evidence plan` |
| Story v3 | documentation_exception | `### Documentation exception` under `## Delivery evidence plan` |
| Story v3 | automated_tests_exception | `### Automated-test exception` under `## Delivery evidence plan` |
| Story v3 | instrumentation_exception | `### Instrumentation exception` under `## Delivery evidence plan` |
| Story v3 | nonfunctional_requirements | `## Non-functional requirements` |
| Story v3 | review_evidence | `## Review evidence`, with document, test, and instrumentation entries mapped by stable ID |
| Story v3 | supplemental_demonstration | `**Supplemental demonstration:**` bullet under `## Review evidence` |
| Task v2 | ticket_quality_additions | `**Additions:**` bullet under `## Ticket quality` |
| Task v2 | approved_exceptions | `**Approved exceptions:**` bullet under `## Ticket quality` |
| Design Spike v2 | design_artifact | `**Artifact:**` bullet under `## Design artifact` |
| Design Spike v2 | reviewers | `**Reviewers:**` bullet under `## Design artifact` |
| Design Spike v2 | checklist_coverage | `**Checklist coverage:**` bullet under `## Design artifact` |

The `**Profile:**` line under `## Release quality` and `## Ticket quality` names the completion profile from [ticket-quality-and-completion.md](ticket-quality-and-completion.md). It is fixed template text with no manifest key. Keep it. It is a reference, not the copied checklist the anti-bloat rule forbids.

The `review_evidence.approved_exceptions` list renders under the `**Approved exceptions:**` bullet. Each entry contains the excepted obligation, status `confirmed`, and the original matching `approval_evidence`. Do not repeat the reason or approver.

## Authorization boundary

The template controls structure. It does not authorize content. Apply renders only values in the approved manifest. Adding scenarios, assumptions, criteria, exceptions, references, or technical detail requires a new manifest revision, Review, digest, and approval.

## Review checks

Flag only material defects:

- missing required content
- unresolved placeholders or empty sections
- vague or generic evidence
- repeated facts or criteria
- Epic acceptance criteria copied from success measures
- generic completion checklists copied into the ticket
- conditional content that does not help implementation or verification
- unsupported detail presented as fact

Give the smallest correction. Do not expand a valid ticket to satisfy a preferred writing shape.

## ADF rendering

When Jira accepts Atlassian Document Format:

- Use native panels, tables, headings, lists, and code blocks.
- Regenerate `localId` values. Never copy them from an exemplar.
- Render Jira references as `inlineCard` nodes outside code blocks.
- Keep Gherkin in a `codeBlock` with `language: gherkin`; code blocks cannot contain inline cards.
- Preserve the selected template's section order.
- Omit unused conditional sections before rendering.
- Read the written issue back as raw ADF and compare normalized structure and text.

ADF normalization removes regenerated `localId` properties only. Serialize the remaining document as UTF-8 JSON with object keys sorted, array order preserved, and no insignificant whitespace; then calculate SHA-256. Preserve text, headings, panels, tables, lists, code-block language, marks, and link targets.

When Jira accepts only plain text or Markdown, preserve the same content and section order. Report any format limitation that materially changes the approved result before Apply.
