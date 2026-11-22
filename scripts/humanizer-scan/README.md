# Humanizer scan prototype

Use the runner for an explicit, scan-only editorial check. The model does not
decide whether to run it. Nothing installs, rewrites, or commits. The existing
Humanizer skill (4.8.1), its modes, and optional Vale checks stay unchanged.

From a checkout, use Python 3.8+ and a working, authenticated CLI:

```sh
python3 scripts/humanizer-scan/scan.py --backend codex draft.md
python3 scripts/humanizer-scan/scan.py --backend claude --mode personal draft.md
python3 scripts/humanizer-scan/scan.py --backend codex - < draft.md
```

Input must be nonempty UTF-8, at most 32 KiB. Engineering mode is the default.
The backend receives the rubric and draft, not the draft's path. Use only
material approved for the selected provider. The prototype makes no claim that
either provider runs inference locally. Scan results contain source excerpts;
keep them private and do not log actual work drafts in CI.

The runner starts the backend from a temporary directory. Codex receives a
read-only filesystem sandbox and never asks for approvals. This does not
isolate Codex from MCP servers or other tools configured in the active profile;
the rubric alone cannot enforce tool access. Use only synthetic drafts for the
prototype. Before scanning real drafts, verify a trusted Codex profile has no
mutating tools. Claude starts with built-in tools disabled and uses strict MCP
configuration plus a tool deny rule. Existing account policies still apply.
No credentials are installed, copied, or reconfigured.

The runner prints a single JSON object. Exit 0 with `status: "findings"` means
the scan returned at least one `fix` or `review` finding. Exit 0 with
`status: "clean"` means the scan reported none; it may list protected `keep`
findings. Exit 2 with `status: "scan_failed"` means the scan could not complete
or the runner rejected its output. Command-line argument errors also use
exit 2. The source SHA-256 ties successful output to the input bytes. An anchor
uses a one-based line number and zero-based Unicode code-point offsets
(start inclusive, end exclusive). The runner verifies quotes and locations
against the original draft. It does not verify the model's editorial judgment.

The direct command is the prototype's entry point. This branch does not enforce
a scan when someone invokes the existing installed skill by name in chat.

## Tests

```sh
python3 tests/humanizer-scan-test.py
python3 tests/humanizer-fixture-test.py
./scripts/validate-skills.sh
python3 tests/humanizer-scan-live.py --case delete-filler --case keep-exact-error
```

The first three commands check behavior with stub hosts, existing fixture
contracts, and skill packaging. The last command calls both authenticated
backends on the same synthetic cases. Omit `--case` to run all new scan
fixtures, or repeat it to choose cases. The live script reports expected,
missing, and additional categories, and proposed fixes touching labeled
protected spans. Review findings by hand: extra categories on a seeded sample
may be valid. Neither stub tests nor invocation from a checkout prove installed
skill behavior in either chat host.
