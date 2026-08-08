# Requirements

## Problem

The writing skills now have strict mode, final gates, pattern classes, and manual regression fixtures. They still need a mechanical lint layer for stable surface tells.

## Desired change

- Add optional Vale support to `agent-skills`.
- Keep runtime skill use optional: strict mode runs Vale only when available, then falls back to manual checks.
- Enforce Vale in repo CI for the repo's own Markdown/default paths.
- Add a wrapper script that lints default repo paths or caller-supplied files/directories.

## Scope decisions

- Repository scope: `agent-skills` only.
- No Flow installer changes in this slice.
- Vale support is a tool layer, not a replacement for skill judgment.

## Versioning

- `humanizer`: `4.4.0` to `4.5.0`
- `doc-flow-review`: `1.3.0` to `1.4.0`

