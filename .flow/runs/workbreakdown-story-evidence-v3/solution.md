# Accepted Solution

Introduce template set 3 and a new `jira-story-v3` template. Preserve all existing template identities and hashes.

Template set 3 selects Story v3 and reuses unchanged v2 Epic, Task, and Spike contracts through explicit compatible-set metadata. Manifest validation checks compatibility metadata rather than requiring a template's original set to equal the selected set. Story v2 remains compatible only with set 2; Story v3 is compatible only with set 3.

Keep the evidence model in the Story description and lifecycle validator. Do not add Jira fields, subtasks, or copied completion checklists.

New Story v3 drafts plan three evidence classes: documentation, automated integration or functional tests, and instrumentation. Before `IN REVIEW`, evidence must reconcile to each plan by stable ID. A complete approved exception may replace any individual class.
