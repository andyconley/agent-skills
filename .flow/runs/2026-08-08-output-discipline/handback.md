# Handback

## Summary

Updated both writing skills to enforce concise, human agent output by default. Added shared output discipline, examples, and manual regression prompts.

## Proof

- `./scripts/validate-skills.sh`
- `./tests/install-test.sh`

## Remaining risk

Manual regression prompts can catch obvious wordiness, but they do not guarantee every host model will obey the contract. Behavior still depends on the agent loading and respecting the skill text.

