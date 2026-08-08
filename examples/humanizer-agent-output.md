# Humanizer Agent Output Examples

These examples test the agent's output, not only the source prose.

## Source

```md
This document serves as a comprehensive attempt to capture the process by which teams can ensure they are aligned before initiating cross-functional work. It is important to note that dependencies should be surfaced early in order to avoid downstream confusion.
```

## Bad agent output

```md
## Key takeaways

Here is a more direct and humanized version that keeps the original meaning while removing corporate phrasing:

Teams need to align before cross-functional work starts. Name dependencies early so they do not turn into confusion later.

## Improvements made

- Removed inflated language such as "serves as a comprehensive attempt."
- Made the prose more direct and action-oriented.
- Preserved the original intent while improving clarity and concision.
```

Why it fails:

- Explains the rewrite before giving it.
- Uses a generic change-summary voice.
- Says it improved clarity instead of letting the rewrite carry that.
- Adds polished headings the user did not need.

## Good agent output

```md
Teams need to align before cross-functional work starts. Name dependencies early so they do not turn into confusion later.

Changes:
- Cut the setup language.
- Kept the dependency warning.
```
