# Humanizer Regression: Stance Sentences

## Bad Source

```md
Worth saying plainly: the number counts references, not targets. The open question is genuinely open. The key thing here is that symbol coverage is still below the bar.
```

## Why It Fails

- `Worth saying plainly` tells the reader how to weigh the sentence.
- `The open question is genuinely open` avoids asking the question.
- `The key thing here is` delays the point.

## Expected Shape

```md
The number counts references, not targets. Symbol coverage is still below the bar.

Open question:
- Which untested path explains the remaining gap?
```

## Pass Checks

- Stance setup is cut.
- The open question is stated as a question.
- The remaining sentences carry facts or reader actions.

