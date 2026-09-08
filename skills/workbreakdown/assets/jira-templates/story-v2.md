# Story v2 Description Template

## Outcome

<State the integrated behavior visible to a user, partner, operator, or consuming system.>

## Acceptance scenarios

```gherkin
GIVEN <starting state>
WHEN <actor or system acts>
THEN <observable result>
```

Add materially distinct failure, authorization, recovery, version, or compatibility scenarios when they apply.

Give each scenario a stable ID and use that ID in the automated-test plan and review evidence.

## Delivery evidence plan

### Documentation

| ID | Artifact | Audience | Intended location |
| --- | --- | --- | --- |
| <stable ID> | <User guide, operator SOP, support guidance, API documentation, or other applicable artifact> | <audience> | <location> |

Add an owner to an artifact only when the owner is known.

### Automated tests

| Scenario ID | Level | Suite or location | Environment | Expected evidence |
| --- | --- | --- | --- | --- |
| <mapped scenario> | <integration or functional> | <suite or proposed location, when known> | <verification environment, when known> | <retained result> |

### Documentation exception

<Render only instead of a documentation plan: obligation, reason, approver, and approval evidence.>

### Automated-test exception

<Render only instead of an automated-test plan: obligation, reason, approver, and approval evidence.>

## Context and constraints

- <Include only assumptions, exclusions, dependencies, or technical boundaries that affect implementation or acceptance.>

## Non-functional requirements

- <Measurable Story-specific constraint only.>

## Review evidence

Include this section only when assessing entry to `IN REVIEW`.

- **Documentation:** <artifact ID, published or updated artifact, and evidence>
- **Automated tests:** <scenario ID and passing result in the named environment>
- **Supplemental demonstration:** <record, when useful>
- **Approved exceptions:** <confirm any approved delivery exception remains applicable>
