---
name: check
description: Run a read-only PASS/FAIL audit of the complete Python hello project, Git state, build, and CI configuration.
agent: build-engineer
---

Verify the entire Python hello project in strictly read-only mode. Do not create, edit, delete, install, build, stage, or commit anything. Do not run commands that may change project files. Do not fix failures; report them for a separate authorized command.

## Read-only rules

- Inspect files and Git metadata only. Never run `pip install`, create or activate a virtual environment, run `ci.sh` or `ci.bat`, or invoke any command that creates `dist/hello.py`.
- Do not run tests if the available invocation may write bytecode or pytest cache. If executing pytest, use an existing Python environment and disable writes, for example `python -B -m pytest -p no:cacheprovider` with `PYTHONDONTWRITEBYTECODE=1`. Do not install pytest. If no suitable existing environment is available, statically validate the test and report that it was not executed.
- Check Git status before and after any test execution. If verification unexpectedly changes a file, stop, report it, and do not attempt to undo the change.
- Never print secret values. Use a redacted secret scanner when available.

## Checks

Inspect the repository root and verify each item below. A missing file, invalid configuration, failed command, or check that cannot be verified is a `FAIL`; explain the reason. Do not infer success from filenames alone when contents can be checked safely.

1. **Git repository and branch:** Verify the current directory is in a Git worktree, identify the repository root, and report `git branch --show-current`. A failed Git query or detached HEAD is `FAIL`.
2. **Required project files:** Confirm these exist: `.gitignore`, `README.md`, at least one documentation file under `docs/`, `src/hello.py`, `src/add.py`, `requirements.txt`, `pytest.ini`, `run.sh`, `run.bat`, `tests/test_basic.py`, `ci.sh`, `ci.bat`, and `.github/workflows/ci.yml`. Also confirm the agent files exist: `.github/agents/build-engineer.agent.md`; skills `project-scaffold`, `build-and-test`, and `github-actions`; and prompts `git-init`, `create-project`, `create-build`, `create-actions`, `check`, and `init`.
3. **`.gitignore`:** Verify it contains rules for `.venv/`, `dist/`, `build/`, `__pycache__/`, `*.pyc`, and `.pytest_cache/`, and confirm Git treats the corresponding generated paths as ignored.
4. **Python source:** Use a read-only syntax check such as Python's `ast.parse` for `src/hello.py` and `src/add.py`; do not use `py_compile`, which writes bytecode. If executing the Hello World script or checking the addition function, use Python with `-B` and verify exact output and representative results. Do not run either in a way that writes files. Confirm `hello.py` prints exactly `Hello, World!` and `add.py` defines `add(a, b)` returning `a + b`.
5. **Dependencies and pytest configuration:** Verify `requirements.txt` declares pytest and `pytest.ini` configures discovery of `tests/` and import access to `src/`.
6. **Run scripts:** Inspect `run.sh` and `run.bat` and verify they use `.venv` and launch `src/hello.py`, with errors propagated rather than hidden.
7. **Unit test:** Verify `tests/test_basic.py` defines `test_basic_addition` and tests the `add` function. Run it with an existing environment and cache/bytecode writing disabled when possible; otherwise report static validation and that execution was not available. Never install dependencies.
8. **CI scripts:** Inspect `ci.sh` and `ci.bat`; verify they create or reuse `.venv`, install declared dependencies, run pytest, stop on failure, and copy `src/hello.py` to `dist/hello.py` only after tests succeed. Check the scripts propagate copy/build errors.
9. **Build output feasibility:** Do not execute the build. Statically verify both CI scripts have a reachable copy step targeting `dist/hello.py` from `src/hello.py`, occurring after successful pytest, and that their directory/copy operations can produce the artifact. If `dist/hello.py` already exists, inspect it without changing it; its absence alone is not a failure when both scripts can produce it.
10. **GitHub Actions workflow:** Validate `.github/workflows/ci.yml` structure (use `actionlint` when available) and verify `push` and `pull_request` triggers for `develop` and `master`, exactly one job with a matrix containing `ubuntu-latest`, `windows-latest`, and `macos-latest`, checkout, Python setup, Windows `ci.bat`, Linux/macOS `ci.sh`, and artifact upload from `dist/` after the CI script. Ensure a failed test fails the job and missing artifacts do not pass silently. If `actionlint` is unavailable, report this and perform a careful structural validation; a malformed or inconclusive structure is `FAIL`.
11. **Tracked generated paths:** Use read-only Git queries such as `git ls-files` to confirm `.venv/`, `dist/`, `build/`, `__pycache__/`, `.pytest_cache/`, and `*.pyc` have no tracked files. Separately verify the required ignore rules apply. Any tracked generated content is `FAIL`.
12. **Tracked secrets:** Check tracked file paths and run an available secret scanner against tracked repository content/history in redacted mode (for example, `gitleaks git --redact`). Do not display secret values. Any detected secret, or inability to perform a meaningful secret check, is `FAIL` with a safe summary only.
13. **Read-only integrity:** Report the Git status observed before and after verification. Any changes caused by this check are `FAIL`; do not revert them.

## Required report

Return a Markdown table with one row for every check above and columns `Check`, `Result`, and `Details`. Each result must be exactly `PASS` or `FAIL`; include specific evidence or a concise failure reason. Do not omit unavailable checks: mark them `FAIL` and explain what prevented verification.

After the table, report one overall status:

- `PASSED` only if every row is `PASS`.
- `FAIL` if any row is `FAIL`.

Explain each failure clearly and do not modify files automatically. Never report `PASSED` when a check failed, was skipped, or could not be verified.
