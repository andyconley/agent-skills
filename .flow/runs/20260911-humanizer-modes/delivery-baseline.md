# Delivery baseline

Captured 2026-09-12T05:25:46.668976+00:00. Refresh before each shared mutation.

Remote main: 37fc25e586040e170d4543ee52bab461ff103bca. Latest release v1.5.1. Feature branch not published and no PR exists.
Canonical checkout: 5140bab00c24606fbd71fdfb0edc658f159b0fb4, main, only untracked current run. Preserve that directory before fast-forward. Worktree baseline 37fc25e.
Both runtime humanizer and doc-flow-review links point to /Users/andyconley/Documents/agent-skills/skills/<name>. Installed humanizer 4.7.0. Both workbreakdown links absent.
User-approved plan authorizes one delivered commit/PR/merge/install with both live runtimes. All writes serialized by coordinator. Recovery: feature commits and canonical baseline remain addressable in git; old run copied out before checkout; managed symlinks can be restored to recorded targets. No destructive reset or force-push planned.

Bootstrap --help in the worktree treated its .git file as noncanonical and created a clean clone at /Users/andyconley/agent-skills; it did not install or repoint links. Actual command help was subsequently checked through scripts/manage-skills.sh in the worktree. This clone is an incidental local artifact, not the delivery target.
