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

## Author-state source

```md
What I concluded, and what I'm not claiming: fix both defects and TS symbol coverage still lands near 48%. Two things I didn't test may matter more. My first read of this was wrong. The open question is genuinely open.
```

## Bad author-state output

```md
What I concluded is that fixing both defects still leaves TS symbol coverage near 48%. I'm not claiming the remaining gap is fully explained. Two things I didn't test may matter more. The open question is genuinely open.
```

Why it fails:

- Keeps the author as the subject.
- Preserves stance sentences that carry little information.
- Makes the reader track the author's analysis instead of the finding.

## Good author-state output

```md
Fixing both defects still leaves TS symbol coverage near 48%.

Limits:
- The remaining gap may have other causes.
- Untested: the two highest-risk coverage paths.

Correction:
- Earlier, this note used the wrong count.

Open question:
- Which untested path explains the remaining gap?
```
