---
name: init
description: Orchestrate the complete build-engineer lab workflow in order and report success only after check returns PASSED.
agent: build-engineer
---

Orchestrate the full lab workflow by reading and executing the instructions in the prompt files listed below, in the exact order shown. This `init` prompt is responsible for carrying out the instructions itself using the available file and terminal tools.

Do not try to invoke the child prompts as slash commands, delegate them to another agent, or stop because a slash-command interface is unavailable. Do not treat checking that prompt files exist as executing their instructions. Read the full prompt file and any skill it references, then perform its required actions and verification before moving on. Use the prompt and skill contents as the authoritative procedure; do not invent a replacement workflow.

## Required command order

1. `.github/prompts/git-init.prompt.md`
2. `.github/prompts/create-project.prompt.md` and `.github/skills/project-scaffold/SKILL.md`
3. `.github/prompts/create-build.prompt.md` and `.github/skills/build-and-test/SKILL.md`
4. `.github/prompts/create-actions.prompt.md` and `.github/skills/github-actions/SKILL.md`
5. `.github/prompts/check.prompt.md`

For each step, read the named file or files, execute every required action with available tools, and complete the specified verification. A step is not complete merely because its prompt or skill file was found or read. Do not modify generated project files except as explicitly authorized by the current step's instructions.

## Orchestration rules

- Before beginning, state that the five steps will be executed in the required sequence.
- Complete and verify one step before starting the next. After each step, record `PASS` or `FAIL` with concrete evidence of its actions and verification; an error, conflict, incomplete action, or inconclusive verification is `FAIL`.
- Stop immediately on the first `FAIL`. Do not read-and-execute or perform later steps after that failure. Report which steps were not run.
- Run the read-only `check` instructions last. The check must execute the audit and produce its complete PASS/FAIL results; merely reading its instructions is not a check. Its overall result must be `PASSED`.
- Report overall `SUCCESS` only if all five steps were actually executed in order, each of the first four passed its verification, and the final `check` returned `PASSED`. Otherwise report overall `FAILURE`.
- Keep reruns safe. Respect each prompt's idempotence and conflict handling, preserve existing user content, and never force an overwrite or delete files to make the sequence pass.

## Safety restrictions

- Never delete user files or unrelated content.
- Never rewrite Git history or run destructive Git commands.
- Never stage, commit, or push automatically. Do not expose or commit secrets.
- Do not bypass failed tests, validation checks, or safety checks.
- Do not claim that a command passed unless its result explicitly confirms success.

## Final report

Provide a Markdown table with one row for each of the five ordered commands and columns `Step`, `Command`, `Result`, and `Details`. Include every step: mark later commands `FAIL` with `Not run because step N failed` if execution stopped early. Summarize the files created or verified by completed commands, grouping related paths where practical, and note any remaining unverified files or platforms.

End with exactly one overall status, `SUCCESS` or `FAILURE`, following the gating rules above. `SUCCESS` is allowed only when the final `check` result is `PASSED`; if it returned `FAIL`, list the failed checks and do not claim success.
