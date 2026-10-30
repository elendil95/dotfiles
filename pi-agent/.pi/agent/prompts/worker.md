---
description: Implement one narrow slice with a fresh worker
argument-hint: "<slice: what to build, done-when, validate-with>"
---

Launch one `worker` subagent (fresh context, the single writer) for this one slice:

$@

Before launching, make sure the task prompt contains everything the worker gets — the worker must not have to explore:
- The slice: one self-contained task with a named deliverable.
- The files: exact paths from the scout brief. context.md is attached to the worker automatically (its default read) — reference it, do not paste the whole brief.
- Acceptance criteria: what "done" looks like, concretely.
- Validation: the targeted command(s). Two relevant test files beat the full suite.

If no scout brief exists for this area (no context.md and no brief in this conversation), launch a `scout` first, then the worker.

Working rules:
- One writer against the worktree: do not launch any other worker while this one runs.
- If the worker reports it needs compaction to finish, the slice is too big — stop, split the slice, relaunch fresh.
- On completion, present me: changed files, commands run with exit codes, validation evidence, surprises, anything left undone. Do not commit.
