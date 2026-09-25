# Acceptance review: security and privacy

- **Verdict:** accept, with no Critical or Important findings.
- **Public repository:** there are no private Jira keys, names, product terms, page IDs, private repository names or internal URLs.
- **Skill wording:** Jira content is treated as untrusted data, Apply stays fail-closed, and the unbound Epic never authorizes a write.
- **Private harness:** it is GET-only with an allowlisted path prefix. The agent has no credentials and only read tools, and S3 proves that from the tools actually offered.
- **Suggestions, all adopted:**
  - Scrub private local paths from the public run files (73543d9).
  - Refuse HTTP redirects and run the public validator without `ATLASSIAN_*` (KB df96ce8).
  - Guard against the zsh re-run looping forever (KB df96ce8).
  - Seal user hooks. This is covered by `--restricted`, which ignores the settings files.
