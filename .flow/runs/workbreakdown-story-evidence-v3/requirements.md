# Requirements

Strengthen the workbreakdown Story contract without invalidating approved manifests.

Before a Story enters `IN REVIEW`, it must provide reviewable evidence for:

1. Passing automated integration or functional tests. Unit and manual tests do not satisfy this obligation.
2. Implemented instrumentation plus observed output from a named representative environment. Use the smallest meaningful combination of operational signals and business metrics.
3. Documentation appropriate to the Story. Evidence may show a new publication, a specific update, or a recorded review confirming that an existing artifact remains correct.

Each evidence class may instead use one complete approved exception containing the obligation, reason, approver, and approval evidence.

The gate applies to `IN REVIEW`, not `IMPLEMENTATION READY`. New drafts use a new immutable contract. Existing template assets and approved manifests remain valid and are never migrated silently.
