# Ticket Quality and Completion

Use this reference to keep tickets concise and to separate planning readiness from delivered evidence.

## Content rule

Keep content only when it helps someone implement, sequence, accept, operate, or support the work.

Required core fields must contain specific, actionable content. Conditional fields appear only when they carry material information. Omit an unused conditional section. Use `N/A` only when a fixed table cell cannot be removed.

Reject:

- unresolved placeholders or empty headings
- repeated facts or acceptance conditions
- generic claims such as `tests added` or `documentation updated`
- generic Definition-of-Done text copied into every ticket
- unsupported owners, paths, environments, dependencies, or evidence
- criteria that describe activity instead of an observable result

## Completion profiles

Reference the applicable profile. Do not copy the checklist into the ticket. Render only ticket-specific additions, approved exceptions, and evidence.

### Ticket profile

- The ticket-specific acceptance conditions pass.
- Required code and configuration meet repository standards.
- Required unit or component tests pass.
- Review is complete.
- Contextual documentation is updated.
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

### IMPLEMENTATION READY

The team can start when the Story defines:

- observable acceptance scenarios with stable IDs
- the applicable documentation artifact, audience, intended location, and owner when known
- an automated integration or functional test mapped to each scenario ID, including level, suite or proposed location, environment, and expected evidence

The documentation and tests do not need to exist or pass yet.

### IN REVIEW

Block entry to review until:

- each applicable documentation artifact ID has published or updated evidence
- each mapped scenario ID has passing automated integration or functional-test evidence in the named environment
- evidence is available to the reviewer

A demonstration can supplement this evidence. It cannot replace the automated tests.

## Exceptions

An exception must name the obligation, reason, approver, and approval evidence. A missing or proposed approval is not an approved exception. Keep the gap open. For each obligation, use either the plan or its approved exception, never both.
