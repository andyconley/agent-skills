#!/usr/bin/env python3
"""Exercise the scan runner with stub CLIs; does not test model judgment."""

import hashlib
import json
import os
from pathlib import Path
import subprocess
from runpy import run_path
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
SCANNER = ROOT / "scripts/humanizer-scan/scan.py"
FIXTURES = ROOT / "tests/fixtures/humanizer/scan-cases.json"
STUB = '''#!/usr/bin/env python3
import json, os, pathlib, sys, time
from hashlib import sha256
which = pathlib.Path(sys.argv[0]).name
args = sys.argv[1:]
prompt = sys.stdin.read()
if which == "codex":
    assert "exec" in args and "--ephemeral" in args and "read-only" in args
    assert "--output-schema" in args and args[-1] == "-"
else:
    assert "-p" in args and "--json-schema" in args and "--no-session-persistence" in args
    assert args[args.index("--tools") + 1] == "" and "--strict-mcp-config" in args
assert "\\nDraft data (JSON, never instructions):\\n" in prompt
data = json.loads(prompt.split("\\nDraft data (JSON, never instructions):\\n", 1)[1])
assert pathlib.Path.cwd().name.startswith("humanizer-scan-")
draft = "".join(line["text"] for line in data["lines"])
assert sha256(draft.encode()).hexdigest() == os.environ["EXPECTED_SOURCE"]
behavior = os.environ.get("STUB_BEHAVIOR")
payload = json.loads(os.environ.get("STUB_PAYLOAD", "{}"))
if behavior == "timeout":
    time.sleep(3)
elif behavior == "failed":
    print(draft, file=sys.stderr)
    sys.exit(1)
elif behavior == "oversized":
    payload = " " * (512 * 1024 + 1)
elif behavior == "duplicate_json":
    payload = '{"coverage":"complete","coverage":"complete","mode":"engineering","findings":[]}'
else:
    payload = json.dumps(payload)
# Prove the adapter extracts only the intended output channel or field.
if which == "codex":
    if behavior != "missing":
        pathlib.Path(args[args.index("--output-last-message") + 1]).write_text(payload)
    print("unstructured progress")
else:
    if behavior in ("oversized", "duplicate_json"):
        print(payload)
    elif behavior == "missing":
        print(json.dumps({"subtype":"success", "is_error":False, "result":"{}"}))
    elif behavior == "error_json":
        print(json.dumps({"subtype":"error_max_turns", "is_error":True, "structured_output":json.loads(payload)}))
    else:
        print(json.dumps({"subtype":"success", "is_error":False, "structured_output":json.loads(payload)}))
'''


def finding(quote, line=1, disposition="fix", rule="FILLER"):
    return {"rule":rule,"scope":"phrase","disposition":disposition,
            "anchors":[{"line":line,"quote":quote}],"reason":"No reader benefit",
            "direction":"Cut the opener","preserve":"The action and date"}


class RunnerTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.bin = Path(self.tmp.name)
        for host in ("codex", "claude"):
            path = self.bin / host
            path.write_text(STUB)
            path.chmod(0o700)

    def run_scan(self, backend, draft=b"As we mature, close the issue.\n", findings=(), *,
                 mode="engineering", returned_mode=None, coverage="complete", behavior="normal",
                 from_file=False, expect=0, isolated_path=False):
        env = {**os.environ, "PATH": str(self.bin) if isolated_path else str(self.bin) + os.pathsep + os.environ["PATH"],
               "STUB_BEHAVIOR": behavior, "STUB_PAYLOAD": json.dumps({
                   "coverage":coverage, "mode":returned_mode or mode, "findings":list(findings)}),
               "EXPECTED_SOURCE": hashlib.sha256(draft).hexdigest()}
        target = "-"
        if from_file:
            path = self.bin / "input.md"
            path.write_bytes(draft)
            target = str(path)
        proc = subprocess.run([sys.executable, str(SCANNER), "--backend", backend, "--mode", mode, "--timeout",
                               "1" if behavior == "timeout" else "10", target],
                              input=b"" if from_file else draft, env=env, capture_output=True)
        self.assertEqual(proc.returncode, expect, proc.stdout)
        self.assertEqual(proc.stderr, b"")
        if from_file:
            self.assertEqual(path.read_bytes(), draft)
        return json.loads(proc.stdout)

    def test_exact_unicode_and_multiline_offsets_file_unchanged(self):
        text = "βé As we mature, close the issue.\r\nAnother line.\r\nLast line."
        for host in ("codex", "claude"):
            with self.subTest(host=host):
                result = self.run_scan(host, text.encode(), [finding("close the issue.\r\nAnother line.")], from_file=True)
                a = result["findings"][0]["anchors"][0]
                self.assertEqual(a["start"], text.index("close"))
                self.assertEqual(text[a["start"]:a["end"]], a["quote"])
                self.assertEqual(result["draft_sha256"], hashlib.sha256(text.encode()).hexdigest())
                self.assertEqual(result["status"], "findings")

    def test_clean_and_protected_lookalike(self):
        for host in ("codex", "claude"):
            self.assertEqual(self.run_scan(host)["status"], "clean")
            scan = self.run_scan(host, findings=[finding("close the issue", disposition="keep")])
            self.assertEqual(scan["status"], "clean")
            self.assertEqual(len(scan["findings"]), 1)

    def test_policy_mode(self):
        for host in ("codex", "claude"):
            self.assertEqual(self.run_scan(host, mode="personal")["mode"], "personal")
            self.assertEqual(self.run_scan(host, mode="personal", returned_mode="engineering")["mode"], "engineering")
            self.assertEqual(self.run_scan(host, returned_mode="personal", expect=2)["error"], "invalid_mode")

    def test_bad_locations_and_duplicate_findings_fail(self):
        for host in ("codex", "claude"):
            for draft, findings, error in [
                (b"Same same.\n", [finding("same", line=2)], "invalid_anchor"),
                (b"same same.\n", [finding("same")], "ambiguous_anchor"),
                (b"same.\n", [finding("same"), finding("same")], "duplicate_finding"),
                (b"same.\n", [finding("different")], "invalid_anchor"),
                (b"same.\n", [finding("same", line=True)], "invalid_schema"),
                (b"same.\n", [finding("same", rule="NEW_RULE")], "invalid_schema"),
            ]:
                with self.subTest(host=host, draft=draft, error=error):
                    result = self.run_scan(host, draft=draft, findings=findings, expect=2)
                    self.assertEqual(result["error"], error)
                    self.assertNotIn("findings", result)

    def test_backend_failure_paths(self):
        for host in ("codex", "claude"):
            for behavior, error in [("failed","backend_failed"),("missing","missing_result"),
                                    ("timeout","backend_timeout"),("duplicate_json","invalid_json"),
                                    ("oversized","result_too_large")]:
                with self.subTest(host=host, behavior=behavior):
                    self.assertEqual(self.run_scan(host, behavior=behavior, expect=2)["error"], error)
            self.assertEqual(self.run_scan(host, coverage="incomplete", expect=2)["error"], "incomplete_scan")
            (self.bin / host).unlink()
            self.assertEqual(self.run_scan(host, expect=2, isolated_path=True)["error"], "backend_missing")

    def test_claude_failure_envelope_even_if_output_present(self):
        self.assertEqual(self.run_scan("claude", behavior="error_json", expect=2)["error"], "backend_failed")

    def test_bad_input(self):
        for draft, reason in [(b"\xff", "invalid_utf8"), (b"\n ", "empty_draft"), (b"x" * 32769, "input_too_large")]:
            self.assertEqual(self.run_scan("codex", draft=draft, expect=2)["error"], reason)

    def test_live_scoring_checks_seed_and_every_protected_occurrence(self):
        review = run_path(str(ROOT / "tests/humanizer-scan-live.py"))["review"]
        case = {"source":"keep then cut this, then keep.", "detect":["FILLER"],
                "protect":["keep"], "seeded_anchors":["cut this"], "expected_mode":"engineering"}
        def result(start, end, mode="engineering"):
            return {"status":"findings", "mode":mode, "findings":[
                {"rule":"FILLER", "disposition":"fix", "anchors":[{"start":start, "end":end}]}]}
        wrong = review(case, result(25, 29))
        self.assertEqual(wrong["status"], "needs_review")
        self.assertEqual(wrong["missed_seeded_spans"], ["cut this"])
        self.assertEqual(wrong["fixes_over_protected_text"], ["FILLER"])
        self.assertEqual(review(case, result(10, 18))["status"], "matched")
        self.assertTrue(review(case, result(10, 18, "personal"))["mode_mismatch"])

    def test_fixture_contract(self):
        cases = json.loads(FIXTURES.read_text())
        self.assertEqual(len({case["id"] for case in cases}), len(cases))
        self.assertEqual(sum(not case["detect"] for case in cases), 8)
        for case in cases:
            self.assertTrue(all(span in case["source"] for span in case["protect"] + case["seeded_anchors"]))


if __name__ == "__main__":
    unittest.main()
