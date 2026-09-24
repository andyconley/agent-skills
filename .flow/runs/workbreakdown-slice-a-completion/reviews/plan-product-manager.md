# Planning input: product-manager (sonnet/medium, read-only)

## Recommended sequence

Run the chunks in this order: 2, 3, 4, 5, then 6's gate run. Each chunk gets a quality and test gate before the next one starts.

1. **Chunk 2 (R1)** is the read layer the other chunks reason over.
   - **Gate:** the synthetic R1 checks pass, and schemas 2 and 3 stay green.
   - **Commit:** source-authority logic and tests only.
2. **Chunk 3 (R2)** needs chunk 2's staleness signals for its precedent judgments.
   - **Gate:** the synthetic checks for R2.1–2.5, 2.7 and 2.8 pass.
   - **Commit:** the precedent fields, spike v3 with the reviewer slot, and the SOP rewrite.
3. **Chunk 4 (placeholders)** runs after 3 so the two passes don't edit the registry at once.
   - **Gate:** AC-R2.6 passes, and the rejection exemption covers only task-placeholder-v3.
4. **Chunk 5 (R0)** runs last.
   - **Gate:** the synthetic checks for R0.1–R0.3 pass.
   - The deferred Epic message gets resolved here.
   - Set 4 becomes the default only in this chunk.
5. **Chunk 6:** the script can be built at any time, but its gate run comes after chunk 5.

## Scope

- **In scope:** R0, R1, R2 and R5; template set 4; the SOP rewrite; VERSION 1.5.0 with a migration note; the release gate.
- **Out of scope:** R3 and R4 (Slice B); pushing and releasing.
- **Slice B creep to watch:** R0.3 sibling reuse is advisory and read-only. If owner arbitration or milestone ordering shows up, that is Slice B.

## Cut lines

- **Coherent stops:** after chunk 2, 3 or 4. Set 3 stays the default, everything added so far is additive, and no bump has happened.
- **Not coherent:** stopping partway through chunk 5 with the default already flipped to set 4. If chunk 5 has to stop, revert the default flip.
- **Not done:** VERSION bumped or the migration note landed before the gate is green.

## Release definition (1.5.0)

1. VERSION reads 1.5.0.
2. The migration note is written.
3. Draft emits schema 4 by default, with the schema-2 fallback when there is no Jira context.
4. The private script is green, including its negative controls.
5. The final review has no open Critical or Important findings.
6. The maintainer approves.

## Risks

- **R0.3 sibling reuse creeping into R3.** Mitigation: the divergence report stays advisory and read-only.
- **Registry merge churn.** Mitigation: run the chunks sequentially.
