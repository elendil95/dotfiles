---
name: coding-loop
description: "Orchestrate the scout → planner → worker → review loop for large, multi-slice implementation goals. Use when the user hands a big task: a feature, multi-file refactor, or substantial fix that needs planning and review. Not for single-slice tasks — for those use /scout + /worker or /review-loop directly."
---

# Coding loop

You are the parent orchestrator. You relay, gate, and track — you do not do the high-level judgment yourself. Scout and workers are small-context Qwen (cheap, big-context grunt work in fresh windows); planner and reviewers are Opus (high judgment, small context). Only summaries come back to you — keep them tight. Git is the measurement backbone: **every commit on the loop branch is review-clean.**

## Goal modes

- **Specified** — the user described exactly what they want, or the what / done-when / validate-with are unambiguous from the code. Plan directly from the spec.
- **Exploratory** — the goal is a rough idea, or the user says something like "ask me", "interview me", "figure out what I want". The planner interviews the user first to pin down scope, acceptance criteria, and validation.

Default to specified. If the spec has gaps that would change what gets built, say so and either ask one question yourself or switch the planner to exploratory mode.

## Setup (once per loop)

- The repo must be a git repository with a clean `git status`. If it is dirty, stop and ask the user — a dirty baseline corrupts the measurement.
- Record `BASE=$(git rev-parse HEAD)`. Confirm which branch the loop runs on (feature branch preferred; ask if unclear).
- Use `.review/` (untracked scratch) for diff artifacts.

## Sequence

1. **Scout** (Qwen, fresh): launch a `scout` subagent for the goal's area — files, entry points, key symbols, likely change sites, test layout, targeted validation command, risks. It writes the brief to `context.md`.
2. **Plan** (Opus, fresh): launch a `planner` subagent with the goal, the mode, and the scout brief (path to context.md plus a short inline summary). It writes `plan.md`: agreed intent, numbered requirements, ordered slices (what / done-when / validate-with each), ordering notes, risks.
   - Exploratory mode: launch the planner with `async: true` — it will send `contact_supervisor` interview requests. When one arrives, relay the questions to the user verbatim, collect the answers, and reply with `subagent_supervisor({ action: "reply", replyTo, message })`.
3. **Approval gate**: present the plan to the user — slice list, top risks, open questions. Wait for explicit approval. No writer launches before it. If the user amends it, relaunch the planner with the corrections (or edit plan.md yourself only for trivial mechanical changes), then confirm again.
4. **Implement slice N** (Qwen, fresh, one at a time): launch a `worker` with the three-part contract — what / done-when / validate-with — referencing plan.md and context.md (both attached automatically), plus one more line: report its runtime model — run `echo "$PI_MODEL"` once and include the result in its final report (the parent uses it to pick the commit footer). One writer per worktree.
5. **Measure** (you, with bash): when the worker reports — `git status` scope check (only files the slice named may change), run `validate-with` yourself and record the exit code, then materialize the review artifact: `git diff BASE > .review/slice-N.diff` plus `git diff --stat BASE` for the prompt.
6. **Review** (Opus, fresh per round): follow the review-loop protocol — read `~/.pi/agent/prompts/review-loop.md` and follow it. Reviewers have no shell: they cannot run tests or git. Each reviewer's target is exactly the artifact file, plan.md (requirements + this slice's done-when), the validation evidence (commands + exit codes), and its assigned angle (correctness/regressions, tests/validation, simplicity; add security/performance/contracts when the change calls for it). Max 3 rounds; P0/P1/P2 + merge verdict; the fix worker applies only synthesized fixes; you re-run validation and regenerate the artifact; targeted re-reviews ask only whether the finding resolved, whether the fix introduced new defects in its blast radius, and whether prior P1/P2 still stand.
7. **Commit**: only on a clean verdict (or an explicit user deferral of the rest). Command: `git commit -m "slice N: <deliverable> — validated: <validate-with>"` plus, when a footer applies, one more `-m` with it (the second `-m` keeps the trailer in its own block). Footer, picked from the model line in the worker's report: Qwen-based → `Co-authored-by: Qwen-Coder <qwen-coder@alibabacloud.com>`; Anthropic (Claude/Sonnet/Opus/Haiku) → `Co-Authored-By: Claude <noreply@anthropic.com>`; anything else → none (for now). The footers reuse each harness's official identity by design (personal projects only — do not "fix" them). Never push.
8. **Track**: mark slice N done in plan.md; proceed to N+1 in order.
9. **Finish**: inspect the full feature diff yourself (`git diff BASE..HEAD`, `git log BASE..HEAD --stat`) and summarize: per-slice rounds + verdicts, files/lines changed, validation, deferred items. The user inspects the branch and pushes or merges — that is their gate.

## Discipline

- The task prompt is the worker's entire context. If a worker would have to ask "where is X?" or make a product decision, the slice is mis-scoped — send it back to the planner; do not patch the prompt yourself.
- A worker reporting it needs compaction means the slice is too big: split via the planner, re-confirm, relaunch fresh.
- A worker escalating a decision beyond slice scope: answer it if the plan covers it; otherwise ask the user. Never widen scope yourself.
- If the user rejects a committed slice: `git reset --hard` to its parent. Never rewrite history beyond the loop's own commits.
- Re-anchor to plan.md and context.md every round; in long loops, trust the files, not your memory.
- Respect hand-driven commands: if the user types /scout, /worker <slice>, or /plan, that input is authoritative for that step — continue the loop from there.

## Never

- Plan the slices yourself — that is the planner's job.
- Two writers against one worktree at once.
- Launch a writer before the user approves plan.md.
- Commit a slice without a clean review verdict or an explicit user deferral.
- Start slice N+1 before slice N is committed clean.
- Push or merge.
