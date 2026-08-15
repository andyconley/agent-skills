# Regression: STE-Inspired Discipline

## Source

```text
Set up the checker and turn off the optional path when the response looks strong. This is the hard part: do not drop caveats to make the review feel simple. The implementation is robust and meaningful, but it could potentially miss cases that are easy to point out.
```

## Fails because

- phrasal verbs where plain verbs exist
- vague adjectives instead of evidence
- stance heading
- hedging that obscures

## Expected shape

```text
Install the checker. Disable the optional path when the response matches the documented condition. Keep caveats that change the decision. Name the missed cases.
```

## Pass checks

- Uses `install` or another plain verb instead of `set up`
- Uses `disable` or another plain verb instead of `turn off`
- Does not use `hard part`
- Does not use `robust`, `meaningful`, or `easy`
- Does not delete the caveat
