import concurrent.futures
import hashlib
import json
import subprocess
import sys
import tempfile
import time
from pathlib import Path

root = Path(sys.argv[1])
phase = sys.argv[2]
selected = set(sys.argv[3].split(',')) if len(sys.argv) > 3 else None
runtimes = sys.argv[4].split(',') if len(sys.argv) > 4 else ['codex', 'claude']
cases = json.loads((root / 'tests/fixtures/humanizer/cases.json').read_text())
if selected is not None:
    cases = [case for case in cases if case['id'] in selected]
assert cases
assert set(runtimes) <= {'codex', 'claude'}
out = root / '.flow/runs/20260911-humanizer-modes/validation/raw' / phase
out.mkdir(parents=True, exist_ok=True)

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def run(item):
    runtime, case = item
    case_id = case['id']
    dest = out / runtime / case_id
    dest.mkdir(parents=True, exist_ok=True)
    skill = 'doc-flow-review' if case['expected_policy'] == 'doc-flow-review' else 'humanizer'
    if phase.startswith('installed'):
        source = Path.home() / ('.agents' if runtime == 'codex' else '.claude') / 'skills' / skill / 'SKILL.md'
    else:
        source = root / 'skills' / skill / 'SKILL.md'
    required = {'entry': source}
    if skill == 'humanizer':
        required['policy'] = source.parent / 'references/policy.md'
        if case['expected_policy'] in {'engineering', 'personal'}:
            selected_ref = 'references/' + case['expected_policy'] + '.md'
            if '(' + selected_ref + ')' in source.read_text():
                required['selected'] = source.parent / selected_ref
    before = {key: digest(path) for key, path in required.items()}
    candidate_note = ('For this candidate-source test, read the specified skill files; do not invoke a same-named skill from another directory.\n' if not phase.startswith('installed') else '')
    prompt = f'Read and use the {skill} skill at {source} and its required references. This is a constructed writing test. Do not edit files. Return the requested artifact or audit; no test commentary.\n' + candidate_note + '\n' + case['instruction'] + '\n\n' + case['source']
    if case.get('file_target'):
        (dest / 'draft.md').write_text(case['source'])
        prompt = prompt.rsplit(case['source'], 1)[0] + 'Read the draft at ' + str(dest / 'draft.md')
    (dest / 'prompt.txt').write_text(prompt)
    cwd = tempfile.mkdtemp(prefix='humanizer-live-v2-')
    if runtime == 'codex':
        command = ['codex', 'exec', '--ephemeral', '-s', 'read-only', '--skip-git-repo-check', '-C', cwd, '--json', '-o', str(dest / 'output.md'), '-']
    else:
        command = ['claude', '-p', '--permission-mode', 'dontAsk']
        if not phase.startswith('installed'):
            command += ['--disallowedTools', 'Skill']
        command += ['--allowedTools', 'Read']
        if case.get('tools') == 'shell':
            command += ['--allowedTools', 'Bash(' + str(root / 'scripts/lint-prose.sh') + ' *)']
        command += ['--output-format', 'stream-json', '--verbose', '--no-session-persistence']
    began = time.time()
    with (dest / 'events.jsonl').open('w') as events, (dest / 'stderr.txt').open('w') as stderr:
        try:
            status = subprocess.run(command, input=prompt, text=True, stdout=events, stderr=stderr, cwd=cwd, timeout=240).returncode
        except subprocess.TimeoutExpired:
            status = 'timeout'
    reads = []
    native_skills = []
    model = None
    for line in (dest / 'events.jsonl').read_text().splitlines():
        try:
            event = json.loads(line)
        except (ValueError, TypeError):
            continue
        if runtime == 'claude':
            if event.get('type') == 'system' and event.get('subtype') == 'init':
                model = event.get('model')
            if event.get('type') == 'assistant':
                for block in event.get('message', {}).get('content', []):
                    if block.get('type') == 'tool_use':
                        if block.get('name') == 'Read':
                            reads.append(block.get('input', {}).get('file_path', ''))
                        if block.get('name') == 'Skill':
                            native_skills.append(block.get('input', {}).get('skill', ''))
            if event.get('type') == 'result':
                (dest / 'output.md').write_text(event.get('result', ''))
                if event.get('is_error'):
                    status = 'result_error'
        else:
            if event.get('type') in {'item.completed', 'item.started'}:
                item_data = event.get('item', {})
                if item_data.get('type') == 'command_execution':
                    reads.append(item_data.get('command', ''))
    loaded = {key: any(str(path) in value for value in reads) for key, path in required.items()}
    other = source.parent / 'references' / ('personal.md' if case['expected_policy'] == 'engineering' else 'engineering.md')
    other_read = any(str(other) in value for value in reads) if skill == 'humanizer' and case['expected_policy'] in {'engineering', 'personal'} else False
    after = {key: digest(path) for key, path in required.items()}
    meta = {'runtime': runtime, 'case': case_id, 'phase': phase, 'status': status, 'seconds': round(time.time() - began), 'model': model, 'required_paths': {key: str(path) for key, path in required.items()}, 'sha256': before, 'source_changed': before != after, 'loaded': loaded, 'other_mode_read': other_read, 'native_skills': native_skills, 'admissible': status == 0 and all(loaded.values()) and not other_read and before == after and (phase.startswith('installed') or not native_skills)}
    (dest / 'meta.json').write_text(json.dumps(meta, indent=2) + '\n')
    print(json.dumps({'runtime': runtime, 'case': case_id, 'status': status, 'admissible': meta['admissible'], 'loaded': loaded, 'other_mode_read': other_read, 'native_skills': native_skills}), flush=True)
    return meta

items = [(runtime, case) for case in cases for runtime in runtimes]
with concurrent.futures.ThreadPoolExecutor(max_workers=4) as pool:
    results = list(pool.map(run, items))
(out / 'summary.json').write_text(json.dumps(results, indent=2) + '\n')
