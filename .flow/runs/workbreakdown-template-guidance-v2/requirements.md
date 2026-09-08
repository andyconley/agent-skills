# Workbreakdown Template Guidance v2 Requirements

## Problem

The bundled Jira templates preserve issue structure but do not give an agent enough direction to produce consistently useful content. Vague placeholders invite filler, while requiring every section invites artificial bloat. The current Epic template can also collapse acceptance criteria into success criteria, and the Story template does not make contextual documentation or automated integration and functional tests explicit completion gates.

## Outcome

Update `workbreakdown` so Draft, Review, and Apply produce concise Jira descriptions whose content is specific, actionable, independently verifiable, and appropriate to the issue type. Preserve approved v1 manifests while making v2 templates the default for new Drafts.

## Required behavior

- Preserve the distinction between success criteria, acceptance criteria, and Definition of Done.
- Epic acceptance criteria state binary milestone conditions and their evidence. They must not repeat or defer to success metrics.
- Story acceptance criteria describe observable behavior. Each Story identifies the applicable user, operator, support, API, or other documentation deliverable.
- Each Story identifies automated integration or functional tests, the scenarios they prove, the intended environment, and the expected evidence.
- Missing Story documentation or automated integration/functional tests blocks transition to `IN REVIEW`. It does not block `IMPLEMENTATION READY`, which means the team has enough information to start work.
- A documentation or automated-test exception requires explicit review and approval. The agent cannot silently waive either requirement.
- Task acceptance criteria describe the specific implementation or operational result. Ticket-level Definition of Done covers code quality, unit tests, review, documentation, and demonstration where applicable.
- A design Spike identifies the decision, key questions, constraints, options, design artifact, reviewers, applicable design-checklist areas, downstream effect, and independently verifiable closure conditions.
- Do not force design-document obligations onto investigation or feasibility Spikes. Select a separate template variant when needed.

## Anti-bloat requirements

- Omit irrelevant optional sections. Use `N/A` only when the target Jira structure requires a value.
- Do not repeat the same fact across context, acceptance criteria, Definition of Done, and evidence.
- Every sentence must help someone decide, implement, review, test, operate, support, or accept the work.
- Do not insert generic process checklists into every ticket. Reference a named Definition-of-Done profile and record only applicable additions, exceptions, or evidence.
- Prefer a few materially distinct scenarios over exhaustive permutations.
- Do not copy a technical design into a design-Spike ticket. Name and validate the linked design artifact.
- Do not invent owners, document locations, test suites, environments, evidence, approvals, or exceptions. Preserve material unknowns.

## Compatibility and distribution

- Retain v1 template identities and behavior for manifests already bound to them.
- Add v2 template identities and make them the default for new Drafts.
- Advance the manifest schema because Apply gains new Epic mutation authority. The Epic uses explicit verification or field-level change semantics; omission preserves live fields.
- Keep the distributed guidance host-neutral and free of internal Jira keys, internal Confluence links, credentials, or runtime integration requirements.
- Preserve the current fail-closed Apply authorization and exact manifest-approval boundary.
- Apply can update an Epic description and acceptance content only when the exact Epic payload, template identity, and manifest revision or digest were reviewed and directly authorized.

## Acceptance

- Automated contract checks prove that v1 and v2 templates remain present and distinguishable.
- Manual Draft tests prove that proposed tickets use concise, populated v2 descriptions without empty boilerplate.
- Manual Review tests flag duplicated Epic criteria, trivial content, Story documentation gaps, Story automated-test gaps, and misplaced Definition-of-Done content.
- Manual state tests prove that missing Story documentation or automated tests blocks `IN REVIEW`, not `IMPLEMENTATION READY`.
- Contract and Apply tests prove that Epic updates are field-scoped, drift-checked, journaled, and verified by final readback while omitted Epic fields remain unchanged.
- Existing install, uninstall, version, lint, and Apply-safety tests continue to pass.
