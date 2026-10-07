---
name: git-init
description: Safely verify the current Git repository and prepare its .gitignore without destructive Git actions.
agent: build-engineer
---

Prepare the Git repository safely. This command may update only the repository-root `.gitignore`; it must not delete user files or modify Git history.

## Procedure

1. Verify that the current directory is inside a Git working tree by running a read-only Git query such as `git rev-parse --is-inside-work-tree`. If the query fails or returns false, stop immediately, report that the folder is not a Git repository, and make no changes.
2. Resolve the repository root with `git rev-parse --show-toplevel`. Use the root `.gitignore` even if the command was invoked from a subdirectory, and report the resolved root.
3. Check the current branch with `git branch --show-current`. Report the branch name. If the result is empty, report that HEAD is detached; do not switch branches.
4. Inspect the current Git status and the repository-root `.gitignore` before editing. Preserve all existing entries and user changes. If `.gitignore` is a directory, symlink, unreadable, or contains non-text data, stop and report the issue rather than replacing it.
5. Ensure the root `.gitignore` includes each of these entries as an ignore rule:

   ```gitignore
   .venv/
   dist/
   build/
   __pycache__/
   *.pyc
   .pytest_cache/
   ```

   If the file does not exist, create it with these entries. If it exists, append only missing entries, preserving all existing useful rules, comments, ordering, and line endings as far as practical. Do not duplicate entries already present as standalone rules. Do not remove, reorder, or rewrite existing content. If safe preservation is uncertain, stop and explain why.
6. Re-read `.gitignore` and verify all six required rules are present. Check the final Git status and inspect the `.gitignore` diff or content to identify exactly what changed. If no additions were needed, report that it was already compliant.

## Safety restrictions

- Never delete existing user files or remove useful `.gitignore` entries.
- Never rewrite Git history or run destructive Git commands. Do not use commands such as `git clean`, `git reset`, `git checkout`, `git restore`, or `git rm` for this task.
- Do not switch branches, stage changes, commit, or push. Never commit automatically.
- Do not inspect, print, stage, or commit secrets. Do not alter any file other than the repository-root `.gitignore`.
- Keep the operation idempotent: running it again must leave an already-compliant `.gitignore` unchanged.

## Reporting

Clearly report:

- Whether the current directory was verified as a Git working tree and the resolved repository root.
- The current branch, or that HEAD is detached.
- The relevant status checked before and after.
- Whether `.gitignore` was created, updated with specific missing entries, or already compliant.
- Any error or reason the operation stopped.

Stop and report an error without changing files if the Git repository check fails. Do not claim success unless the required ignore rules have been verified.
