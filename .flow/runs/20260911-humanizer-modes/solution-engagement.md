# Solution engagement
Engineer confirmed scope: approved humanizer mode/audit/strict rules with unchanged doc-flow-review behavior. Answers: backward compatibility for existing invocations/lint commands is not required; lint configuration and scripts may change; constructed personal fixtures first. No new requirements approval requested.
Solution lane started through CLI at 2026-09-12T04:27:55Z. Current lifecycle: solutioning, not approved.

## Retrieval and advice
Solution archive search selection ea56bf9f42eef5537e10c0e10b137728a132143394759e0524391efcf9aecf6a: unavailable (project/ancestor identity missing). Do not repeat automatically. No returned hits; local precedent is manually inspected outside selection. Earlier flow doctor found project manifest missing and coverage unknown. No backfill scope.
Coordinator advice: judgment, gpt-5.6-sol/high, provisional; active parent unknown per flow model context; no switch. Capacity/history cannot establish quality or lower needed posture.

## Newly inspected evidence
scripts/lint-prose.sh passes arguments to Vale using a single tools/vale/.vale.ini. That config applies AgentVoice to md/txt. .github/workflows/ci.yml bypasses wrapper and invokes Vale action directly. tools/vale/styles/AgentVoice/AuthorState.yml errors on source first-person phrases; PlainVerbs.yml warns on ordinary phrasal verbs. Thus wrapper-only changes cannot isolate personal samples from CI engineering rules.
install.sh bootstraps then calls scripts/manage-skills.sh; latter installs skill directory symlinks. Any policy-module references require installed path validation; do not claim packaging support from source inspection alone.
Existing manual prompts demonstrate engineering sweeps, protected parallelism, word choice, mixed documents; tests/manual/README.md explicitly says they are regression checks, not objective scoring. Preserve this proof boundary.

## Applicable standards
Architecture / Core principles: reversible decisions and boundaries aligned to domain concepts favor explicit mode policy ownership.
Architecture / Layering and Domain rules: policy selection is distinct from optional Vale integration; deterministic wrapper checks do not prove editorial judgments.
Architecture / ADR convention: durable cross-skill domain changes merit ADR; a humanizer-local implementation can use run solution record without creating a generic framework.
Evidence / Whether the evidence could have failed: exercise overediting as well as missed defects; choose assertions that reject plausible incorrect output.
