---
name: init
description: Orchestrate the complete build-engineer lab workflow in order and report success only after check returns PASSED.
agent: build-engineer
---

Orchestrate the full lab workflow by invoking the existing commands below, in the exact order shown. Run them serially; wait for each command to finish and evaluate its result before invoking the next one. Never run steps in parallel, skip a step, or continue after an error.

## Required command order

1. `git-init`
2. `create-project`
3. `create-build`
4. `create-actions`
5. `check`

Invoke each as its corresponding workspace prompt command (for example, `/git-init`). Do not replace a command with an improvised implementation. Follow each command's own instructions and safety rules.

## Orchestration rules

- Before beginning, state that the workflow will run in the required sequence.
- After each command finishes, record its result as `PASS` or `FAIL` with a concise explanation. A command that errors, reports failure, stops on a conflict, returns an incomplete result, or cannot be verified is `FAIL`.
- Stop immediately on the first `FAIL`. Do not invoke any later command. Report which step failed and which later steps were not run.
- `check` must run last and must return overall `PASSED`. A `FAIL`, missing result, or inconclusive check is not success.
- Report overall `SUCCESS` only if all five commands completed in order, the first four succeeded, and the final `check` returned `PASSED`. Otherwise report overall `FAILURE`.
- Keep the workflow safe to rerun. Respect each command's idempotence and conflict-handling rules; preserve existing user content and never force an overwrite to make the sequence pass.

## Safety restrictions

- Never delete user files or unrelated content.
- Never rewrite Git history or run destructive Git commands.
- Never stage, commit, or push automatically. Do not expose or commit secrets.
- Do not bypass failed tests, validation checks, or safety checks.
- Do not claim that a command passed unless its result explicitly confirms success.

## Final report

Provide a Markdown table with one row for each of the five ordered commands and columns `Step`, `Command`, `Result`, and `Details`. Include every step: mark later commands `FAIL` with `Not run because step N failed` if execution stopped early. Summarize the files created or verified by completed commands, grouping related paths where practical, and note any remaining unverified files or platforms.

End with exactly one overall status, `SUCCESS` or `FAILURE`, following the gating rules above. `SUCCESS` is allowed only when the final `check` result is `PASSED`; if it returned `FAIL`, list the failed checks and do not claim success.
