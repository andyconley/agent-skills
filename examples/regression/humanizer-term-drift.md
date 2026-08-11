# Humanizer Regression: Term Drift

## Bad Source

```md
Each job writes its output to a folder under the run root. When a task
fails, the retry handler reads the same directory and replays the work
item from the last checkpoint.
```

## Why It Fails

- `job`, `task`, and `work item` name one concept.
- `folder` and `directory` name one location.
- The reader cannot tell whether a retry replays the same unit that failed.

## Expected Shape

```md
Each job writes its output to a directory under the run root. When a job
fails, the retry handler reads that directory and replays the job from
the last checkpoint.
```

## Pass Checks

- One name per concept, held for the whole passage.
- The chosen name is the one the codebase already uses.
- No name is introduced only to avoid repeating the first one.
- The rewrite does not add a glossary line to explain the collapsed terms.
