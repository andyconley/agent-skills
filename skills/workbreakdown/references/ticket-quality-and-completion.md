# Ticket Quality and Completion

Use this reference to keep tickets concise and to separate planning readiness from delivered evidence.

These rules apply to every ticket regardless of template set. A manifest bound to template set 1 keeps its frozen template and its own declared keys, and still meets this content bar. Where a v1 template has no key for an obligation below, Review and Audit enforce the obligation as a lifecycle judgment rather than as a manifest field.

## Content rule

Keep content only when it helps someone implement, sequence, accept, operate, or support the work.

Required core fields must contain specific, actionable content. Conditional fields appear only when they carry material information. Omit an unused conditional section. Use `N/A` only when a fixed table cell cannot be removed.

Reject:

- unresolved template tokens or empty headings
- repeated facts or acceptance conditions
- generic claims such as `tests added`, `metrics added`, `dashboard updated`, or `docs reviewed`
- generic Definition-of-Done text copied into every ticket
- unsupported owners, paths, environments, dependencies, or evidence
- criteria that describe activity instead of an observable result

## Card writing

Write each card so someone who was not in the room can identify its outcome, verification, and boundary.

- Use a plain action-and-object title. Keep ticket numbers and writer-only codes out of titles. Preserve required type-specific markers such as `[PLACEHOLDER]`.
- Write short, plain sentences for readers who use English as a second language. Avoid em dashes and semicolons in authored prose. Preserve exact code, quoted evidence, and published identifiers when their syntax requires them.
- Keep context to one or two sentences explaining why the card exists and where it fits. Put implementation rules in the design artifact rather than repeating them in context.
- Before citing a design section, read the published version and verify that the section exists and supports the claim. If it cannot be checked, record the gap rather than inventing an anchor or presenting the claim as verified. A published design does not override the SOP's source-authority rules.
- Put testable outcomes in acceptance conditions. Name responses, state changes, failure behavior, or validation results rather than activities. Retain the Task rule of 2–5 binary conditions. Do not pad a two-condition Task to reach three.
- Limit technical considerations to three short, ticket-specific points a developer could otherwise miss. Keep essential additional detail in the linked design. Do not hide a necessary acceptance condition there to meet a count.
- Name nearby excluded work when a reader could reasonably expect it in this card. Use its purpose or a verified Jira key, never a made-up card ID.
- Do not use meeting citations, requirement-row labels understood only by the writer, or local machine paths in the card. Use published design sections and repository references. Keep provenance and stable scenario/evidence IDs where the manifest or selected template requires them.

Aim for 150–250 words for an ordinary implementation Task, not a mandatory minimum or maximum. A shorter complete card is valid. Spikes, integrated acceptance Stories, and Epics may need more space to retain their required content and evidence. Link supporting artifacts where practical, but keep the card's own acceptance explicit. Do not remove lifecycle obligations or add fields to an approved template to satisfy this guidance.

Before handing over newly drafted or materially revised descriptions, count their words and acceptance conditions. Count visible title and description prose, including table text, but not URL targets or attached artifacts. Report counts and any material sizing concern in the review output, not as new manifest keys or Jira rows. Treat a long card as a prompt to inspect independent outcomes, not a reason to split valid work mechanically. Review and Audit retain their smallest-material-correction rule and do not reformat valid existing cards for style alone.

## Completion profiles

Reference the applicable profile. Do not copy the checklist into the ticket. Render only ticket-specific additions, approved exceptions, and evidence.

### Ticket profile

- The ticket-specific acceptance conditions pass.
- Required code and configuration meet repository standards.
- Required unit or component tests pass.
- Review is complete.
- Contextual documentation is updated.
- Applicable instrumentation is implemented and produces observable output.
- Completion evidence is attached or linked.

### Sprint profile

- Applicable ticket profiles pass.
- Integrated behavior passes in the named environment.
- No unresolved critical defect blocks the sprint outcome.
- Required stakeholder or system-owner approval is recorded.

### Release profile

- Applicable sprint and ticket profiles pass.
- Required system, regression, performance, and compatibility checks pass.
- Release notes, deployment steps, monitoring, and rollback guidance are ready when applicable.
- The release acceptance evidence and acceptor are recorded.

## Story lifecycle gates

### SOLUTION READY

The team can start when the Story defines:

- observable acceptance scenarios with stable IDs
- the applicable documentation artifact, audience, intended location, and owner when known
- an automated integration or functional test mapped to each scenario ID, including level and expected evidence
- the smallest instrumentation plan that proves the Story outcome or an operational decision: operational signals, business metrics, or both, with a stable ID, purpose, implementation target, and expected observation

Name the intended suite or location and the verification environment when they are known. Leave them out when they are not, and record the gap in `unknowns`. A Story is not blocked from starting because the repository, suite, or environment has not been chosen yet. Do not invent either value to satisfy the field.

The documentation, tests, and instrumentation do not need to exist, pass, or emit yet.

### IN REVIEW

Block entry to review until:

- each applicable documentation artifact ID has evidence that it was published, updated, or reviewed and confirmed current
- each mapped scenario ID has passing automated integration or functional-test evidence in a named environment
- the evidence names the environment it ran in, and matches the planned environment when the plan named one
- each planned signal has implementation evidence and observed output from a named representative environment
- evidence is available to the reviewer

A confirmed-current document identifies the reviewer and applicable revision or review record.

Unit tests and demonstrations can supplement this evidence. They cannot replace automated integration or functional tests. Instrumentation code without observed output, or output without implementation evidence, does not pass the gate.

### Legacy Story evidence

Do not rewrite an approved older description only to add current evidence fields. Review and Audit may evaluate a linked or supplied lifecycle-evidence record that identifies the Story key and selected template. The record contains the same three evidence classes or their separate approved exceptions. Automated evidence maps the Story's stable scenario IDs.

When an older description has no scenario IDs, the record assigns a unique ID to each exact scenario text and maps automated evidence to that ID. The binding must cover the existing scenarios exactly once; it does not edit the description. Instrumentation contains a signal ID, class, purpose, implementation evidence, observed output, retained evidence, and a named representative environment.

This record is review input. It does not authorize a Jira mutation or change the approved manifest. Missing legacy evidence still blocks `IN REVIEW`.

## Exceptions

An exception must name one evidence class, its obligation, reason, approver, and approval evidence. A missing or proposed approval is not an approved exception. Keep the gap open. For each class, use either the plan or its approved exception, never both.
