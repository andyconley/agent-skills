# Story v3 Description Template

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
| <stable ID> | <The user, operator, support, API, design, or other artifact this Story needs> | <audience> | <location> |

Add an owner only when known. Plan only the documentation this Story needs.

### Automated tests

| Scenario ID | Level | Suite or location | Environment | Expected evidence |
| --- | --- | --- | --- | --- |
| <mapped scenario> | <integration or functional> | <suite or proposed location, when known> | <verification environment, when known> | <retained result> |

Unit and manual tests may supplement this evidence. They do not satisfy it.

### Instrumentation

| ID | Class | Signal | Purpose | Implementation target | Environment | Expected observation |
| --- | --- | --- | --- | --- | --- | --- |
| <stable ID> | <operational or business> | <precise signal> | <what it proves> | <code, configuration, telemetry, or analytics target> | <when known> | <observable result> |

Use the smallest set of operational signals and business metrics that proves the Story outcome or an operational decision. Do not add a signal only to fill the table.

### Documentation exception

<Render only instead of a documentation plan: obligation, reason, approver, and approval evidence.>

### Automated-test exception

<Render only instead of an automated-test plan: obligation, reason, approver, and approval evidence.>

### Instrumentation exception

<Render only instead of an instrumentation plan: obligation, reason, approver, and approval evidence.>

## Context and constraints

- <Include only assumptions, exclusions, dependencies, or technical boundaries that affect implementation or acceptance.>

## Non-functional requirements

- <Measurable Story-specific constraint only.>

## Review evidence

Include this section only when assessing entry to `IN REVIEW`.

- **Documentation:** <artifact ID; published, updated, or confirmed-current result; and evidence>
- **Automated tests:** <scenario ID and passing integration or functional result in the named environment>
- **Instrumentation:** <signal ID, named representative environment, implementation evidence, observed output, and retained evidence>
- **Supplemental demonstration:** <record, when useful>
- **Approved exceptions:** <for each excepted class, status confirmed and the matching approval evidence>
