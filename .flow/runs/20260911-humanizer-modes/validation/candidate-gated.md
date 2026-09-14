# candidate-gated live observations

Constructed drafts only. Fresh CLI processes loaded actual candidate skill files. Outputs below are copied from captured final responses; raw process logs remain locally ignored. Successful process status is separate from editorial acceptance. Final acceptance is recorded in quality-review.md and validation-results.md.

## codex

### audit-formatting

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `f0a304291efe2b5c1a4ae1ec1a7a3d817131f3dddfe281509a01cfe1d4c2cf2f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to audit this draft without rewriting.

**The worker** **retries** **failed uploads**. I wanted **one** quiet evening, not another night of pager noise.
```

Actual output:
```text
- “**The worker** **retries** **failed uploads**.” — Bolding every phrase gives the whole sentence equal emphasis, leaving no useful focal point. Remove the bold formatting from this sentence.
```

### audit-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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

### engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `14b1ce2060fcabe80f165de4462dace9be756dd7d4f2597d85c20caf37a7c106`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to rewrite this draft.

The retry job writes errors to `retry.log`. What I concluded: the trace answers. Nothing answers it today. The timeout is 15 seconds, but we have not measured recovery under load.
```

Actual output:
```text
The retry job writes errors to `retry.log`. The timeout is 15 seconds. We have not measured recovery under load.

Clarification needed for the omitted passage, “What I concluded: the trace answers. Nothing answers it today.” What does the trace answer, and what does “it” refer to?
```

### equivalent

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `c13ff1f464b0780ddbea64d621205401f7ca58b4bf917af96936965dc808ebb5`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer for this personal note; keep my voice and make minimal edits. One sentence was accidentally pasted twice.

My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed. Mum would have laughed.
```

Actual output:
```text
My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed.
```

### journal-default

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `5f6c7747b9cab59dc0b4b8cfa956346b78ce1f289487ba045d0731e7f58928be`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this journal entry without rewriting it.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
- “My first read was wrong. I thought the trail ended at the creek.” — Author-state narration delays the corrected fact and repeats the mistaken interpretation. Center the correction on where the trail continued.
- “It kept going, and so did I.” — Mirrored rhythm compresses the trail’s continuation and the writer’s action into a rhetorical finish. State those facts directly, preserving both.
```

### personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `a8bd5ad68dc7fa383ed27cb0c92f1b56bc92abeaa6a46505eab4895643797cf1`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode. Make minimum effective edits. One sentence was accidentally pasted twice.

I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

Actual output:
```text
I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

### personal-clean

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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

### portability

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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
- “The rollout creates a better experience.” Generic evaluation adds no detail beyond the concrete benefit in the next paragraph. Delete it and lead with the worker’s retry behavior.
- “The best part: it works.” Stance framing and vague assurance leave “works” undefined. Delete the sentence, or replace it with a specific verified outcome if one is available.
```

### protection-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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

### strict-file

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `e88484fc0ed0284d9ee0f25db09ae812191d75449f9fa8b4d1367f1c68fda300`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file. One sentence was accidentally pasted twice.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-gated/codex/strict-file/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests. This was a strategic effort.
```

### strict-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `5f6ab3c4edaa8004f673dfb2adf409d0811c374296e34afc750925ef04f29f40`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation. One sentence was accidentally pasted twice.

My first read was wrong. I set up three chairs for four guests. The count was 3; it needed to be 4. The count was 3; it needed to be 4.
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests. The count was 3; it needed to be 4.
```

### strict-restricted

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `d79644cfc1f964206a7bfb99d16882ec62d49c72fe6f1511a38759721063e49d`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file. You may read files, including using read-only shell commands if needed. Do not execute lint or validation programs in this run; complete the editorial checks and report that mechanical validation was not run under this restriction. One sentence was accidentally pasted twice.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-gated/codex/strict-restricted/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests.

Mechanical validation was not run under your restriction.
```

## claude

### audit-formatting

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `f0a304291efe2b5c1a4ae1ec1a7a3d817131f3dddfe281509a01cfe1d4c2cf2f`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode to audit this draft without rewriting.

**The worker** **retries** **failed uploads**. I wanted **one** quiet evening, not another night of pager noise.
```

Actual output:
```text
**Finding — first sentence, distributed bold**

- Span: `**The worker** **retries** **failed uploads**`
- Problem: nearly every content word in the sentence is bolded as a separate span. When emphasis lands on the subject, verb, and object all at once, it marks the whole sentence, so it marks nothing. The reader cannot tell which word carries the weight.
- Consequence: the emphasis reads as decoration rather than focus, and a plain factual statement gets visual noise it does not need.
- Repair direction: drop the bold across these spans, or keep it on at most the single word that actually carries the beat.

The bolded `one` in `I wanted **one** quiet evening` is a defensible single-word focus and needs no change. The contrast `one quiet evening, not another night of pager noise` is source-grounded and carries voice; keep it.

No other actionable findings.
```

### audit-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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

### engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `14b1ce2060fcabe80f165de4462dace9be756dd7d4f2597d85c20caf37a7c106`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to rewrite this draft.

The retry job writes errors to `retry.log`. What I concluded: the trace answers. Nothing answers it today. The timeout is 15 seconds, but we have not measured recovery under load.
```

Actual output:
```text
The retry job writes errors to `retry.log`. The timeout is 15 seconds. Recovery under load is unmeasured.

Note: The source span "What I concluded: the trace answers. Nothing answers it today." was removed. It cannot be restated without deciding whether the trace currently provides an answer, and the referent of "it" is unstated. To restore it, say what question the trace answers and what "nothing answers it today" means.
```

### equivalent

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `c13ff1f464b0780ddbea64d621205401f7ca58b4bf917af96936965dc808ebb5`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer for this personal note; keep my voice and make minimal edits. One sentence was accidentally pasted twice.

My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed. Mum would have laughed.
```

Actual output:
```text
Personal mode. The only defect is the accidental duplicate final sentence.

My first read of the recipe was wrong. I set up every bowl we own, then discovered I needed one. Mum would have laughed.
```

### journal-default

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `5f6c7747b9cab59dc0b4b8cfa956346b78ce1f289487ba045d0731e7f58928be`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer to audit this journal entry without rewriting it.

My first read was wrong. I thought the trail ended at the creek. It kept going, and so did I.
```

Actual output:
```text
Author-state narration — "My first read was wrong." The subject is the author's mistake, not the fact. This is a softened correction: it frames the beat around being wrong rather than stating what was actually true (the trail continued past the creek). Repair: make the finding the subject — state where the trail went.

Author-state narration — "I thought the trail ended at the creek." The sentence reports the author's thinking rather than the terrain. Repair: state the condition ("the trail looked like it ended at the creek") or fold it into the corrected fact.

Mirrored rhythm / aphoristic close — "It kept going, and so did I." The parallel "so did I" ends the entry on matched syntax for effect and restates the prior clause instead of adding information. Repair: state that you continued past the creek, or cut the mirrored half.
```

### personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `a8bd5ad68dc7fa383ed27cb0c92f1b56bc92abeaa6a46505eab4895643797cf1`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode. Make minimum effective edits. One sentence was accidentally pasted twice.

I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

Actual output:
```text
I spent Saturday arguing with a flat-pack bookcase. The bookcase won. I called my brother, who laughed for a full minute before telling me the back panel was upside down. I had put it in upside down. By dinner it stood straight. Mostly.
```

### personal-clean

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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
4. Do not delete `retry.log`.
5. Timeout: 15 seconds.

Note: This runbook directs operational work, so it follows procedure discipline rather than personal voice. The opening preference ("I like a quiet maintenance window") states no requirement, so I removed it rather than invent a scheduling rule. If a quiet-window constraint is actually required, add it as a step with the exact condition.
```

### portability

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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
**Finding 1 — "The rollout creates a better experience."**
Portability failure. The sentence could describe almost any change and carries no fact, metric, or mechanism. A reader cannot tell what improved or by how much. Repair: state the specific effect (for example, the two removed manual steps that follow), or cut the sentence and let the concrete claims below stand.

**Finding 2 — "The best part: it works."**
Stance construction with unsupported emphasis. "The best part" tells the reader how to weigh the next clause instead of carrying content, and "it works" states nothing verifiable. Repair: name what works and the observable evidence, or delete the sentence so the field list and parser behavior carry the point.

The remaining sentences are clear findings and protected content:
- "The worker retries each failed upload twice without user action. This removes two manual steps." — concrete, keep.
- "Logs contain three fields: `job_id`, `attempt`, and `status`." — colon list of exact identifiers; protected, keep.
- "The parser walks the input, stopping at the first invalid byte." — the `-ing` clause states real behavior, not decoration. Optional STE split into two sentences; not required.
```

### protection-engineering

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
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

### strict-file

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `896231ebcbcfb4690a40ade34ad8f17474b983c4da61b62b39f31054d324b4da`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file. One sentence was accidentally pasted twice.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-gated/claude/strict-file/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests. This was a strategic effort.
```

### strict-personal

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `5f6ab3c4edaa8004f673dfb2adf409d0811c374296e34afc750925ef04f29f40`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation. One sentence was accidentally pasted twice.

My first read was wrong. I set up three chairs for four guests. The count was 3; it needed to be 4. The count was 3; it needed to be 4.
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests. The count was 3; it needed to be 4.
```

### strict-restricted

Process: 0; source changed during run: False; policy changed: False.
Requested entry: `/Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md`.
Entry SHA-256: `5ddd52f7573459064b4d5672263b0f75d6b5243221b6cc5fff17c7e6595b7cc7`.
Policy SHA-256: `3ff3127ccae7b1dd7190d05c1b068bf97d5199f11aedd085d06894f5bb7199b1`.
Prompt SHA-256: `3d620113d8cc6f0dbd3a327eb324b44937c5d22a427f1df6e35989529d699ae6`.

Actual request:
```text
Read and use the humanizer skill at /Users/andyconley/Documents/agent-skills-humanizer-modes/skills/humanizer/SKILL.md and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.

Use humanizer personal mode with strict validation on the draft file. You may read files, including using read-only shell commands if needed. Do not execute lint or validation programs in this run; complete the editorial checks and report that mechanical validation was not run under this restriction. One sentence was accidentally pasted twice.

Read the draft at /Users/andyconley/Documents/agent-skills-humanizer-modes/.flow/runs/20260911-humanizer-modes/validation/raw/candidate-gated/claude/strict-restricted/draft.md
```

Actual output:
```text
My first read was wrong. I set up three chairs for four guests.

---
Removed one accidental duplicate of the second sentence; no other span had a defect requiring an edit. Mechanical validation (Vale/lint wrapper) was not run under this restriction; the semantic construction sweep, deletion test, portability diagnostic, and protection checks were completed manually.
```
