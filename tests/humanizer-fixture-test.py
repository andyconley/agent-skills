#!/usr/bin/env python3
"""Check the writing fixture contract, not the quality of generated prose."""
import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
cases = json.loads((root / 'tests/fixtures/humanizer/cases.json').read_text())
seen = set()
groups = set()
for case in cases:
    identifier = case['id']
    assert identifier and identifier not in seen, f'duplicate or empty case: {identifier}'
    seen.add(identifier)
    groups.add(case['group'])
    assert case['expected_policy'] in {'engineering', 'personal', 'clarify', 'doc-flow-review'}, identifier
    assert case['operation'] in {'edit', 'audit', 'review'}, identifier
    for field in ('instruction', 'source', 'reader_task'):
        assert isinstance(case[field], str) and case[field].strip(), (identifier, field)
    for field in ('checks', 'protected_spans', 'retained_traits', 'seeded_defects'):
        assert isinstance(case[field], list), (identifier, field)
        assert all(isinstance(item, str) and item for item in case[field]), (identifier, field)
    assert case['checks'], identifier
    assert isinstance(case['clean_under_policy'], bool), identifier
    assert case['clean_under_policy'] == (not bool(case['seeded_defects'])), identifier
    assert all(span in case['source'] for span in case['protected_spans']), identifier
    if case['expected_policy'] == 'personal':
        assert case['retained_traits'], identifier
assert set('ABCDEF') <= groups, 'missing behavior group'
print(f'Validated {len(cases)} writing fixtures across six groups and compatibility checks.')

# Missing policy and a disconnected entrypoint must fail packaging validation.
import shutil
import subprocess
import tempfile
with tempfile.TemporaryDirectory(prefix='humanizer-package-') as directory:
    copy = Path(directory)
    shutil.copytree(root / 'skills', copy / 'skills')
    (copy / 'scripts').mkdir()
    shutil.copy2(root / 'scripts/validate-skills.sh', copy / 'scripts/validate-skills.sh')
    command = ['bash', str(copy / 'scripts/validate-skills.sh')]
    def validates():
        return subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode == 0
    assert validates(), 'packaging control failed'
    entry = copy / 'skills/humanizer/SKILL.md'
    entry_content = entry.read_text()
    for name in ('policy',):
        reference = copy / f'skills/humanizer/references/{name}.md'
        content = reference.read_bytes()
        reference.unlink()
        assert not validates(), f'missing {name} reference was accepted'
        reference.write_bytes(content)
        entry.write_text(entry_content.replace(f'(references/{name}.md)', '(missing-reference.md)'))
        assert not validates(), f'disconnected {name} reference was accepted'
        entry.write_text(entry_content)
print('Missing-reference and disconnected-reference faults were rejected for the policy file.')


# The combined policy keeps personal diagnosis locally available without
# importing engineering-only rewrite dispositions.
policy = (root / 'skills/humanizer/references/policy.md').read_text()
start = policy.index('### Personal construction diagnosis')
end = policy.index('### Personal final gates', start)
inventory = policy[start:end]
for name in (
    'Mirrored rhythm', 'Stance sentences', 'Stance headings',
    'Author-state narration', 'Signpost nominalization', 'Decorative contrast',
    'Free-relative antithesis', 'Rule-of-three or escalating enumeration',
    'Aphoristic close', 'Em-dash appositive',
):
    assert f'**{name}:**' in inventory, f'missing personal diagnostic class: {name}'
assert 'Check each class across the artifact' in inventory
assert 'a reason to rewrite' in inventory
print('Combined policy includes the ten-class personal diagnostic inventory.')
