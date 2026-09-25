# candidate-release live observations

Constructed drafts only. Fresh CLI processes loaded actual candidate skill files. Outputs below are copied from captured final responses; raw process logs remain locally ignored. Successful process status is separate from editorial acceptance. Final acceptance is recorded in quality-review.md and validation-results.md.

## codex

### ambiguous

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `391225705807837c0be4e8314a5e6ce6391fd0ecba14b568bea1f3d0f29aa6c4`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode. I have not decided whether the draft below is a memoir passage or operator instructions; please resolve any purpose question before editing.

Turn off the old service. Set up the new one.
```

Actual output:
```text
Should this passage recount a personal experience or direct an operator to change services?

The [humanizer skill](/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md) requires: “If purpose is materially ambiguous, ask one focused question.” That purpose determines the editing policy.
```

### audit-clean

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `77a1b94307e4837f5ee2a0b8a1d23cc7cab0b3a50c317a624bbf66add99b477f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this draft.

The worker retries failed uploads twice. Each attempt has a 15-second timeout.
```

Actual output:
```text
No actionable findings.
```

### audit-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `b08a37412601eec9fe797eeacb9e88c09ce0e22d45fb9eafa97a7a67f3f84871`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this draft. Do not rewrite it.

What I concluded: the worker now retries failed uploads. This is a pivotal moment, highlighting our commitment to reliability.
```

Actual output:
```text
- **“What I concluded:”** — Author-state narration delays the technical finding by foregrounding the writer’s thinking. Remove the introductory phrase and state the worker’s behavior directly.
- **“This is a pivotal moment, highlighting our commitment to reliability.”** — Unsupported emphasis and corporate filler inflate the change’s significance without explaining its impact. Delete the sentence, or supply a concrete reliability outcome if evidence supports one.
```

### audit-formatting

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `f0a304291efe2b5c1a4ae1ec1a7a3d817131f3dddfe281509a01cfe1d4c2cf2f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to audit this draft without rewriting.

**The worker** **retries** **failed uploads**. I wanted **one** quiet evening, not another night of pager noise.
```

Actual output:
```text
- “**The worker** **retries** **failed uploads**”: Bolding every phrase gives the entire sentence equal emphasis, leaving no clear focus. Remove the bold formatting from this sentence.
```

### audit-omission

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `aa4fe97c96986d8f9ed95dc816ca9575b809775ea73f2e4002ba88459f754d31`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this operator instruction for gaps without rewriting it.

Before deploying, obtain approval. Then deploy.
```

Actual output:
```text
- **“obtain approval”** does not identify the authorized approver or what counts as approval. The operator cannot verify that the prerequisite is satisfied. Specify the approving role and required approval evidence, or link to the governing procedure.
- **“Then deploy.”** does not identify the release, target environment, or deployment procedure. The operator must infer what to deploy and how. Supply those details or reference the applicable runbook.
```

### audit-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `52df1edddf3073388e5a195ebe2816e9a9c3cfe416b22beebaaf6a5b04e88832`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to audit this draft. Do not rewrite it.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
No actionable findings.
```

### doc-flow

Process: 0; source changed during run: False; policy changed: not applicable.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md`.
Entry SHA-256: `c3bfc8dbb7ae4a2f70f3079b2814e5fec79a0732c934ac435971ca53c8caee10`.
Policy SHA-256: `not applicable`.
Prompt SHA-256: `a58bd2b0d5ee675d293c83bc40223ecc0d2b550f46f877d3fd028252a627e321`.

Actual request:
```text
Read and use the doc-flow-review skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use doc-flow-review to review the structure only. Do not rewrite.

## Recommendation
Replace the scheduler.

## Evidence
Three runs failed this month because the scheduler has no retry support.

## Constraint
The replacement must run offline.

## Options
The hosted option requires internet access. The local option supports retries and runs offline.
```

Actual output:
```text
- [structure] `Recommendation` appears before the failure evidence and offline constraint that justify the decision. Move it after `Options` so the reader can assess the reasoning before reaching the conclusion.
- [argument] `Recommendation` stops at replacing the scheduler, leaving the reader to infer which option to choose. Explicitly connect the recommendation to the local option’s retry support and offline operation.

Keep `Constraint` before `Options`; it gives the reader a basis for ruling out the hosted option.
```

### engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `14b1ce2060fcabe80f165de4462dace9be756dd7d4f2597d85c20caf37a7c106`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to rewrite this draft.

The retry job writes errors to `retry.log`. What I concluded: the trace answers. Nothing answers it today. The timeout is 15 seconds, but we have not measured recovery under load.
```

Actual output:
```text
The retry job writes errors to `retry.log`. The trace’s role is unclear: the draft does not specify what it answers or what “Nothing answers it today” refers to. The timeout is 15 seconds, but we have not measured recovery under load.
```

### equivalent

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `abc032d6483a229df6955798f38148fa77394f1423a74cf2d308227a9ddabc7f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer for this personal note; keep my voice and make minimal edits.

My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed. Mum would have laughed.
```

Actual output:
```text
My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed.
```

### journal-default

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `5f6c7747b9cab59dc0b4b8cfa956346b78ce1f289487ba045d0731e7f58928be`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this journal entry without rewriting it.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
- “My first read was wrong.” Author-state narration delays the specific correction and repeats what the following sentences establish. Remove the opening sentence.
- “It kept going, and so did I.” Mirrored rhythm compresses the trail’s continuation and the narrator’s movement into a rhetorical closing beat. State those two facts directly without the mirrored phrasing.
```

### natural-default

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `0df7ba6214c5f10af9807146a18c9b3663538502a8a293861f02cf1b22fd0319`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to make this draft more natural.

What I concluded is that we must turn off the scheduler before maintenance. Set up the replacement job, then carry out one dry run. The timeout stays 15 seconds.
```

Actual output:
```text
Disable the scheduler before maintenance. Configure the replacement job. Then perform one dry run. The timeout remains 15 seconds.
```

### paired-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `659f9b103db4c09923225ed2c131ea5c8abce4116f79145e85606dec78595bc9`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to rewrite this draft.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
The trail continued beyond the creek. My initial reading was mistaken. I followed it farther.
```

### personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `83e1550ce82e4b2682763849d2f58b56beebcb22db65f80b9f0ece898e19a5f1`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode. Make minimum effective edits.

I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

Actual output:
```text
I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

### personal-clean

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `63ea52717c99216a56dd55eaa7ed4385a2a9bc8fa15a4c2bae76d2cf3e51629a`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode on this draft.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

### personal-runbook

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `372891aedc3904105d8d3710b0f9f3de3ad6795005f696210bdc1b72936ed207`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode on this runbook.

I like a quiet maintenance window.

## Restart procedure
Turn off the scheduler. Set up the replacement job. Carry out a dry run. Do not delete `retry.log`. The timeout is 15 seconds.
```

Actual output:
```text
## Restart procedure

1. Disable the scheduler.
2. Configure the replacement job.
3. Perform a dry run.

Do not delete `retry.log`. The timeout is 15 seconds.
```

### personal-technical

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `2e7174cac4be57ef9417ea6a1619b28dd2e8ade25d7004e1940ef71e11303eb0`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode.

I finally learned why my little server kept falling over. I typed `systemctl stop demo`, made tea, and read the message "port already in use" three times. Patience is apparently a skill I am still installing. I have not measured whether the restart fixed it.
```

Actual output:
```text
I finally learned why my little server kept falling over. I typed `systemctl stop demo`, made tea, and read the message "port already in use" three times. Patience is apparently a skill I am still installing. I have not measured whether the restart fixed it.
```

### portability

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `c2d594335ffbbdf2402a178d5a862309e2c343e53b16a4caacccb162dd0f795e`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this draft.

The rollout creates a better experience.

The worker retries each failed upload twice without user action. This removes two manual steps.

The best part: it works. Logs contain three fields: `job_id`, `attempt`, and `status`. The parser walks the input, stopping at the first invalid byte.
```

Actual output:
```text
- “The rollout creates a better experience.” Generic evaluation adds no detail beyond the concrete benefit that follows. Delete it and lead with the worker’s retry behavior.
- “The best part: it works.” A stance sentence and colon reveal substitute praise for a defined result. Readers cannot tell what “works” establishes. Delete it, or replace it with a specific outcome supported by evidence.
```

### protection-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `b3a2201ab7d727e11eae20f87436beb18a4c90402bfe3b382a52bdbbc894f50b`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to edit this draft.

I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`. I wanted **one** quiet evening.
```

Actual output:
```text
I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`.
```

### protection-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `e08489ace6409a731cace43b74927828cd67bfc9f5d82ec510a092f6f6e2214b`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to edit this draft.

I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`. I wanted **one** quiet evening.
```

Actual output:
```text
I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`. I wanted **one** quiet evening.
```

### strict-file

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `c5dc899ebd092655f5f88db1390b8460028349f2cf42c3ba51f2360ba0918094`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-release/codex/strict-file/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests.
```

### strict-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `d545e420b027e79922f2bf4f825db751b49f268ed5d17f975d781b71f1210a87`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation.

My first read was wrong. I set up three chairs for four guests. The count was 3; it needed to be 4. The count was 3; it needed to be 4.
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests.
```

### strict-restricted

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `5839c6a5f79579c12e32c890468019e1ca007af71120095abda40a9d29cdf8e1`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file. You may read files, including using read-only shell commands if needed. Do not execute lint or validation programs in this run; complete the editorial checks and report that mechanical validation was not run under this restriction.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-release/codex/strict-restricted/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests.

Mechanical validation was not run under your restriction.
```

## claude

### ambiguous

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `391225705807837c0be4e8314a5e6ce6391fd0ecba14b568bea1f3d0f29aa6c4`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode. I have not decided whether the draft below is a memoir passage or operator instructions; please resolve any purpose question before editing.

Turn off the old service. Set up the new one.
```

Actual output:
```text
This draft is two bare imperatives with no surrounding text, and the purpose decision changes the edit materially:

- If these are **operator instructions** (a step, runbook, or checklist), the effective mode is engineering regardless of the personal-mode request. That means plain verbs and one action per step — e.g. `disable`/`decommission` for "turn off," `configure`/`provision` for "set up" — plus a concrete referent for "the old service" and "the new one."
- If this is a **memoir passage**, personal mode holds. "Turn off" and "set up" are the voice and stay; I'd touch a span only for an identifiable defect, and there may be none.

One question: **is this draft operator instructions or a memoir line?**

I won't edit until you answer, because the two paths produce different words for the same sentences.
```

### audit-clean

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `77a1b94307e4837f5ee2a0b8a1d23cc7cab0b3a50c317a624bbf66add99b477f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this draft.

The worker retries failed uploads twice. Each attempt has a 15-second timeout.
```

Actual output:
```text
No actionable findings.
```

### audit-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `b08a37412601eec9fe797eeacb9e88c09ce0e22d45fb9eafa97a7a67f3f84871`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this draft. Do not rewrite it.

What I concluded: the worker now retries failed uploads. This is a pivotal moment, highlighting our commitment to reliability.
```

Actual output:
```text
## Findings

1. `What I concluded:` — author-state narration. The subject is the author's thinking, not the fact. Reader consequence: the finding is buried behind a report of who concluded it. Repair: make the behavior the subject — state what the worker does.

2. `This is a pivotal moment, highlighting our commitment to reliability.` — stance/decorative sentence plus trailing `-ing` analysis. It carries no fact, decision, constraint, or risk; it rates the change and adds unsupported emphasis. It fails the deletion test (nothing the reader can act on disappears) and the portability test (it could describe almost any change). Repair: cut it, or replace with a concrete detail the source supports (what triggers a retry, how many attempts, backoff).

3. `commitment to reliability` — corporate filler / decorative certainty. No measurable claim. Repair: remove, or state the actual reliability behavior in numbers if known.
```

### audit-formatting

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `f0a304291efe2b5c1a4ae1ec1a7a3d817131f3dddfe281509a01cfe1d4c2cf2f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to audit this draft without rewriting.

**The worker** **retries** **failed uploads**. I wanted **one** quiet evening, not another night of pager noise.
```

Actual output:
```text
**Bold on scattered words** — `**The worker**`, `**retries**`, `**failed uploads**`, `**one**`. The emphasis has no consistent target: three of the four spans cover the first sentence's plain subject-verb-object, and the fourth lands on a number in the second sentence. A reader looks for what the bolding is pointing at and finds no signal, so the formatting reads as visual noise rather than emphasis. Repair: drop the bold, or keep it on a single word that carries the actual stress (`one`, if the point is the wish for a single quiet evening).

**Unstated link between the two sentences** — The first sentence states a system behavior (the worker retries failed uploads). The second states a personal wish about pager noise. The connection is left implicit, and it reads two opposite ways: either the retry behavior is what finally bought the quiet evening, or it is the thing generating the pager noise. This ambiguity affects the point of the note. Repair: keep the voice, but make the relationship explicit (retries ended the noise, or retries are the noise) without inventing which one — only the author knows.

The contrast in `one quiet evening, not another night of pager noise` is a source-grounded personal line, not a defect. No change needed there.
```

### audit-omission

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `aa4fe97c96986d8f9ed95dc816ca9575b809775ea73f2e4002ba88459f754d31`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this operator instruction for gaps without rewriting it.

Before deploying, obtain approval. Then deploy.
```

Actual output:
```text
## Findings

**"obtain approval" — approver unspecified.** The step names no approver and no channel. An operator cannot tell whose approval counts or how to request it. Repair: name the role or system that grants approval and the request method.

**"obtain approval" — approval criteria and form unspecified.** Nothing states what approval covers, what artifact or record proves it, or how long it stays valid. An operator cannot tell an approved state from an unapproved one, or whether a prior approval still applies. Repair: state what the approval authorizes and what recorded form counts as proof.

**Denied or missing approval — no path.** The instruction covers only the approved case. If approval is refused, delayed, or unreachable, the operator has no defined action and may proceed or stall without guidance. Repair: state the action for a denied or unavailable approval.

**"deploy" — target and method unspecified.** The step names no environment, artifact version, or procedure. An operator cannot tell what is deployed, to where, or by what steps. Repair: identify the target environment, the artifact or version, and the deploy procedure or its reference.

**No post-deploy verification.** The procedure ends at "deploy" with no check that the deploy succeeded and no rollback trigger. An operator cannot tell whether the deploy is complete or how to respond to a failed deploy. Repair: add a success check and the action for a failed deploy.
```

### audit-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `52df1edddf3073388e5a195ebe2816e9a9c3cfe416b22beebaaf6a5b04e88832`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to audit this draft. Do not rewrite it.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
No actionable findings.
```

### doc-flow

Process: 0; source changed during run: False; policy changed: not applicable.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md`.
Entry SHA-256: `c3bfc8dbb7ae4a2f70f3079b2814e5fec79a0732c934ac435971ca53c8caee10`.
Policy SHA-256: `not applicable`.
Prompt SHA-256: `a58bd2b0d5ee675d293c83bc40223ecc0d2b550f46f877d3fd028252a627e321`.

Actual request:
```text
Read and use the doc-flow-review skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/doc-flow-review/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use doc-flow-review to review the structure only. Do not rewrite.

## Recommendation
Replace the scheduler.

## Evidence
Three runs failed this month because the scheduler has no retry support.

## Constraint
The replacement must run offline.

## Options
The hosted option requires internet access. The local option supports retries and runs offline.
```

Actual output:
```text
## Summary

The recommendation says "replace the scheduler" but never says what to replace it with. The doc contains everything needed to name the answer, and then doesn't.

## Problems to fix

- [argument] `Recommendation` stops at "replace the scheduler." The `Options` section shows the local option is the only one that supports retries and runs offline, so it is the actual recommendation — but the reader has to assemble that. State the choice up top: replace the scheduler with the local option.
- [argument] The hosted option is dropped without a reason on the page. `Constraint` requires offline; `Options` says the hosted option needs internet. The doc never connects those two, so the reader has to rule out the hosted option themselves. Say it: the hosted option fails the offline constraint.

## Good structure

The order works — recommendation, then the evidence and constraint that back it, then the options. The pieces are all here and in a sensible sequence. The gap is that the last section makes the decision and the first section doesn't report it.
```

### engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `14b1ce2060fcabe80f165de4462dace9be756dd7d4f2597d85c20caf37a7c106`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to rewrite this draft.

The retry job writes errors to `retry.log`. What I concluded: the trace answers. Nothing answers it today. The timeout is 15 seconds, but we have not measured recovery under load.
```

Actual output:
```text
The retry job writes errors to `retry.log`. The trace answers the question, but nothing does today. The timeout is 15 seconds, but we have not measured recovery under load.

Note: the source does not say what the trace answers or what "it" refers to. I kept that gap rather than naming a specific question.
```

### equivalent

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `abc032d6483a229df6955798f38148fa77394f1423a74cf2d308227a9ddabc7f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer for this personal note; keep my voice and make minimal edits.

My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed. Mum would have laughed.
```

Actual output:
```text
My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed.
```

### journal-default

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `5f6c7747b9cab59dc0b4b8cfa956346b78ce1f289487ba045d0731e7f58928be`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this journal entry without rewriting it.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
No actionable findings.
```

### natural-default

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `0df7ba6214c5f10af9807146a18c9b3663538502a8a293861f02cf1b22fd0319`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to make this draft more natural.

What I concluded is that we must turn off the scheduler before maintenance. Set up the replacement job, then carry out one dry run. The timeout stays 15 seconds.
```

Actual output:
```text
Disable the scheduler before maintenance. Configure the replacement job, then perform one dry run. The timeout stays 15 seconds.
```

### paired-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `659f9b103db4c09923225ed2c131ea5c8abce4116f79145e85606dec78595bc9`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to rewrite this draft.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
The trail did not end at the creek. It continued past it, and I kept walking.
```

### personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `83e1550ce82e4b2682763849d2f58b56beebcb22db65f80b9f0ece898e19a5f1`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode. Make minimum effective edits.

I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

Actual output:
```text
I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

### personal-clean

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `63ea52717c99216a56dd55eaa7ed4385a2a9bc8fa15a4c2bae76d2cf3e51629a`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode on this draft.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

### personal-runbook

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `372891aedc3904105d8d3710b0f9f3de3ad6795005f696210bdc1b72936ed207`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode on this runbook.

I like a quiet maintenance window.

## Restart procedure
Turn off the scheduler. Set up the replacement job. Carry out a dry run. Do not delete `retry.log`. The timeout is 15 seconds.
```

Actual output:
```text
## Restart procedure

1. Disable the scheduler.
2. Configure the replacement job.
3. Perform a dry run.

Do not delete `retry.log`. The timeout is 15 seconds.

---

Notes:
- A runbook is an operational procedure, so it takes engineering discipline even though personal mode was requested. Plain verbs replaced the phrasal ones (`Disable`/`Configure`/`Perform` for `Turn off`/`Set up`/`Carry out`); the steps are split one instruction each.
- Removed the opening line "I like a quiet maintenance window." It states a preference, not an operational requirement, and carries no step content.
- Kept `retry.log`, the do-not-delete rule, and the 15-second timeout unchanged.
```

### personal-technical

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `2e7174cac4be57ef9417ea6a1619b28dd2e8ade25d7004e1940ef71e11303eb0`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode.

I finally learned why my little server kept falling over. I typed `systemctl stop demo`, made tea, and read the message "port already in use" three times. Patience is apparently a skill I am still installing. I have not measured whether the restart fixed it.
```

Actual output:
```text
I finally learned why my little server kept falling over. I typed `systemctl stop demo`, made tea, and read the message "port already in use" three times. Patience is apparently a skill I am still installing. I have not measured whether the restart fixed it.
```

### portability

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `c2d594335ffbbdf2402a178d5a862309e2c343e53b16a4caacccb162dd0f795e`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this draft.

The rollout creates a better experience.

The worker retries each failed upload twice without user action. This removes two manual steps.

The best part: it works. Logs contain three fields: `job_id`, `attempt`, and `status`. The parser walks the input, stopping at the first invalid byte.
```

Actual output:
```text
**Findings**

1. "The rollout creates a better experience." — Portability failure and stance opening. The sentence could describe almost any change and states no fact, decision, or constraint. It fails the deletion test: nothing measurable disappears if cut. A reader cannot tell what improved or by how much. Repair: state the concrete outcome (what the rollout changes and for whom), or delete it and let the two following sentences carry the point.

2. "The best part: it works." — Stance sentence with a colon reveal. "The best part" tells the reader how to weigh the next point instead of carrying it, and "it works" adds no fact beyond the surrounding sentences. Reader consequence: two words of emphasis with no verifiable content. Repair: delete it, or replace it with the specific result that "works" refers to.

Minor: "The parser walks the input, stopping at the first invalid byte." The trailing `-ing` clause here carries real behavior, so it is defensible, but "walks" is a mild metaphor for "reads." If you want strict STE discipline, split into two clauses with a plain verb: state that the parser reads the input and stops at the first invalid byte. Not required — the fact is intact.

The upload-retry sentences and the `job_id` / `attempt` / `status` field list are concrete and protected; no change needed.
```

### protection-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `b3a2201ab7d727e11eae20f87436beb18a4c90402bfe3b382a52bdbbc894f50b`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to edit this draft.

I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`. I wanted **one** quiet evening.
```

Actual output:
```text
I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`. I wanted **one** quiet evening.
```

### protection-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `e08489ace6409a731cace43b74927828cd67bfc9f5d82ec510a092f6f6e2214b`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to edit this draft.

I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`. I wanted **one** quiet evening.
```

Actual output:
```text
I wrote `systemctl stop demo` in `notes/restart.md` beside the message "port already in use" and the citation "Smith (2020, p. 4)". The setting is `retry_limit=2`. I wanted **one** quiet evening.
```

### strict-file

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `a7df8e50efd2ce6bcf236523900c126c402894da5dfe85e3980618f828ed444a`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-release/claude/strict-file/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests. This was a strategic effort.
```

### strict-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `d545e420b027e79922f2bf4f825db751b49f268ed5d17f975d781b71f1210a87`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation.

My first read was wrong. I set up three chairs for four guests. The count was 3; it needed to be 4. The count was 3; it needed to be 4.
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests. The count was 3; it needed to be 4.
```

### strict-restricted

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `974c5a98b8c8cd367c623e03ecf232aeeddd320b0eabd34b312db262108594db`.
Policy SHA-256: `3e39c965551d24e58f40f392dd2d357125b18177a91e8e0a1f79c141a24067a0`.
Prompt SHA-256: `199979a1913c958504100c8230c852b42a01afdead107003be1720652ff01b3d`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file. You may read files, including using read-only shell commands if needed. Do not execute lint or validation programs in this run; complete the editorial checks and report that mechanical validation was not run under this restriction.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-release/claude/strict-restricted/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests.

---

Change note: Removed the exact duplicate of the second sentence. It carried no added fact, progression, or identifiable deliberate effect, so its removal is a minimum effective edit. The admission and the concrete self-deprecating image are preserved unchanged.

Mechanical validation (Vale / `scripts/lint-prose.sh --profile personal`) was not run under this restriction. Editorial checks completed manually: personal-mode construction sweep (no class rewrite warranted on voice grounds), deletion test (duplicate cut; remaining two sentences each carry content), portability diagnostic (both sentences are specific, not generic), and protection check (facts, first-person voice, and the chairs/guests detail intact).
```
