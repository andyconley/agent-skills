#!/usr/bin/env python3
"""Compare real scans of the same public synthetic fixtures on both hosts."""

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CASES = ROOT / "tests/fixtures/humanizer/scan-cases.json"
SCANNER = ROOT / "scripts/humanizer-scan/scan.py"


def overlaps(a, b, c, d):
    return a < d and c < b


def review(case, result):
    if result["status"] == "scan_failed":
        return {"status": "blocked", "error": result["error"]}
    expected = set(case["detect"])
    actionable = [f for f in result["findings"] if f["disposition"] != "keep"]
    observed = {f["rule"] for f in actionable}
    missing = sorted(expected - observed)
    src = case["source"]
    seeded = [(src.index(span), src.index(span) + len(span), span) for span in case["seeded_anchors"]]
    missed_spans = [
        span for low, high, span in seeded
        if not any(overlaps(anchor["start"], anchor["end"], low, high)
                   for finding in actionable if finding["rule"] in expected
                   for anchor in finding["anchors"])
    ]
    protected = [(m.start(), m.start() + len(span)) for span in case["protect"]
                 for m in re.finditer("(?=" + re.escape(span) + ")", src)]
    protected_fixes = [
        f["rule"] for f in actionable if f["disposition"] == "fix" and
        any(overlaps(a["start"], a["end"], low, high)
            for a in f["anchors"] for low, high in protected)
    ]
    unexpected = sorted(observed - expected)
    # Unexpected classes on a seeded draft need a reviewer to decide whether
    # they are helpful additional findings. A clean control should stay clean.
    mode_mismatch = result["mode"] != case["expected_mode"]
    status = "needs_review" if (missing or missed_spans or protected_fixes or unexpected or mode_mismatch) else "matched"
    return {"status": status, "missing_rules": missing, "extra_rules": unexpected, "missed_seeded_spans": missed_spans,
            "fixes_over_protected_text": protected_fixes, "mode_mismatch": mode_mismatch,
            "scan": result}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--case", action="append", help="Select fixture ID; repeat for more.")
    parser.add_argument("--backend", action="append", choices=["codex", "claude"],
                        help="Select a backend; default: both.")
    parser.add_argument("--timeout", type=int, default=120)
    args = parser.parse_args()
    if not 1 <= args.timeout <= 600:
        parser.error("--timeout must be between 1 and 600")
    cases = json.loads(CASES.read_text())
    known = {case["id"] for case in cases}
    if args.case and not set(args.case) <= known:
        parser.error("unknown case ID")
    backends = args.backend or ["codex", "claude"]
    report = {"fixture_set": CASES.name, "hosts": {}}
    for backend in backends:
        executable = shutil.which(backend)
        entry = report["hosts"][backend] = {"cases": {}}
        if executable:
            try:
                ver = subprocess.run([executable, "--version"], capture_output=True, text=True, timeout=10)
                if ver.returncode == 0:
                    entry["cli_version"] = ver.stdout.strip().splitlines()[0]
            except (OSError, IndexError, subprocess.TimeoutExpired):
                pass
        for case in cases:
            if args.case and case["id"] not in args.case:
                continue
            proc = subprocess.run(
                [sys.executable, str(SCANNER), "--backend", backend,
                 "--mode", case["mode"], "--timeout", str(args.timeout), "-"],
                input=case["source"].encode("utf-8"), capture_output=True,
            )
            try:
                result = json.loads(proc.stdout)
                entry["cases"][case["id"]] = review(case, result)
            except (ValueError, KeyError, TypeError):
                entry["cases"][case["id"]] = {"status":"blocked", "error":"invalid_runner_response"}
    print(json.dumps(report, indent=2))
    statuses = [case["status"] for entry in report["hosts"].values()
                for case in entry["cases"].values()]
    return 2 if "blocked" in statuses else 1 if "needs_review" in statuses else 0


if __name__ == "__main__":
    sys.exit(main())
