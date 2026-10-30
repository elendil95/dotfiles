---
description: Scout an area and write the context brief (context.md)
argument-hint: "<area, paths, or symbols>"
---

Launch a `scout` subagent (fresh context, read-only) for this area:

$@

Instructions for the scout task:
- Map the minimum context another agent needs to act: entry points, key types/functions, data flow, files likely to change, test layout, and risks/gotchas.
- The brief is the whole context a later worker will get. If a worker would have to explore to find something, it belongs in the brief.
- Cite exact file paths, with line ranges where useful.
- Name the targeted validation command for this area — the two most relevant test files or commands, not the full suite.

The scout writes its brief to its configured output path (context.md). When it returns, confirm the brief was written and summarize for me in 5-10 lines: files that will change, entry points, the validation command, and the top risks.

This step is recon only — do not launch a worker.
