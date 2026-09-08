# Jira Description Templates

The bundled template set lives in `assets/jira-templates/registry.yaml`. It contains normalized Epic, Story, Task, and Spike description templates derived from working Jira issue structures.

## Selection

Use the bundled template matching the issue type unless the user or project supplies another exact template. A project template wins only when its identity, version, and content are available for review. Never infer a house template from a ticket that was not named as an exemplar.

For every proposed child, put the selected `template_id` and its complete description content in the manifest. Complete every section or state `None` or `N/A`. Do not leave instructional placeholders in a Draft or Jira issue.

Existing issues do not need to be reformatted merely because they use an older template. Change their descriptions only when the approved manifest explicitly includes `template_id` and `description` under `changes`.

## Authorization boundary

The template controls structure. It does not authorize content. Apply may render only the section values in the approved manifest. Adding Gherkin, assumptions, exclusions, references, or technical detail after approval requires a new manifest revision and approval.

## ADF rendering

When Jira accepts Atlassian Document Format:

- Use native panels, tables, headings, lists, and code blocks.
- Regenerate `localId` values. Never copy them from an exemplar.
- Render Jira references as `inlineCard` nodes outside code blocks.
- Keep Gherkin in a `codeBlock` with `language: gherkin`; code blocks cannot contain inline cards.
- Preserve the selected template's section order.
- Read the written issue back as raw ADF and verify its structure and text.

When the available Jira capability accepts only plain text or Markdown, preserve the same section order and content. Report the format limitation before Apply if it materially changes the approved result.
