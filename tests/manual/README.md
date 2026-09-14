# Manual Skill Tests

These prompts check behavior that static validation cannot prove.

Run them against the target agent after changing `humanizer`, `doc-flow-review`, or shared writing QA files.

They are not objective scoring. They are regression checks for known failure modes.

## Pass Standard

- The output passes the selected skill and writing policy gates.
- Engineering output follows the shared pattern rules. Personal humanizer output uses its local policy dispositions; a matched construction alone is not a defect.
- The output stays agent-agnostic: no host-specific tool or product assumptions.

