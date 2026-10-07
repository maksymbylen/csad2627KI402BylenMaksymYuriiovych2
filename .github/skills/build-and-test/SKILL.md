---
name: build-and-test
description: Use when setting up, running, building, or testing the Python hello project with a virtual environment and cross-platform scripts.
---

# build-and-test

Set up the build, run, and test workflow for the Python project using these inputs:

- `src/hello.py`
- `src/add.py`

The source files are prerequisites from the `project-scaffold` skill. Inspect and validate them before relying on them; do not recreate or overwrite them as part of this skill.

## Files created

- `requirements.txt` declares `pytest` as a project dependency.
- `pytest.ini` configures pytest to discover tests in `tests/` and adds `src/` to the import path.
- `run.sh` and `run.bat` create `.venv` when needed, install `requirements.txt`, and launch `src/hello.py`.
- `tests/test_basic.py` contains the pytest test `test_basic_addition`, importing `add` from `src/add.py` and checking ordinary integer addition.
- `ci.sh` and `ci.bat` create or reuse `.venv`, install dependencies, run pytest, and copy `src/hello.py` to `dist/hello.py` only after tests pass.

The build artifact is `dist/hello.py`. Do not clean or delete `dist/` or any other existing files as part of this workflow.

## Safe, repeatable procedure

1. Inspect all target paths before writing. Preserve unrelated user files. Create only missing directories and files. If a target already has the required content, leave it unchanged. If it contains conflicting content, stop and report the conflict instead of blindly replacing it.
2. Ensure the scaffold inputs exist and validate: `src/hello.py` must print `Hello, World!`, and `src/add.py` must define `add(a, b)`. Stop if an input is missing or incompatible; do not modify it here.
3. Create `requirements.txt` with a supported pytest requirement, such as `pytest>=7.0`.
4. Configure `pytest.ini` with `testpaths = tests` and `pythonpath = src`, so tests can import `add` without modifying `sys.path` in the test.
5. Create `tests/test_basic.py` with a test function named exactly `test_basic_addition`; assert representative integer addition such as `add(2, 3) == 5`.
6. Make `run.sh` and `ci.sh` POSIX shell scripts. Start each with `set -eu`; use `python3` to create `.venv` when `.venv/bin/python` is absent, and use `.venv/bin/python` thereafter. Install requirements with `.venv/bin/python -m pip install -r requirements.txt`. `run.sh` launches `.venv/bin/python src/hello.py`. `ci.sh` runs `.venv/bin/python -m pytest`, exits immediately on failure, then creates `dist/` if needed and copies only `src/hello.py` to `dist/hello.py`.
7. Make `run.bat` and `ci.bat` Windows batch scripts. Create `.venv` using `py -3 -m venv .venv` when `.venv\Scripts\python.exe` is absent. Use `.venv\Scripts\python.exe` to install requirements and run the program or pytest. Check `errorlevel` after each operation and exit nonzero immediately on failure. In `ci.bat`, create `dist\` if needed and copy only `src\hello.py` to `dist\hello.py` after pytest succeeds; check the copy result too.
8. Do not require activation of the virtual environment: invoke its Python executable directly. This keeps scripts deterministic across Windows and POSIX shells. Repeated runs may reuse `.venv`, reinstall the declared dependency, rerun tests, and refresh only the intended build output.

## Verification

From the repository root:

1. Confirm `requirements.txt`, `pytest.ini`, both run scripts, both CI scripts, and `tests/test_basic.py` exist.
2. Run `run.sh` with a POSIX shell (`sh run.sh`, or `./run.sh` if executable) and `run.bat` on Windows. Each must print exactly `Hello, World!` and return success.
3. Run `ci.sh` on Linux/macOS and `ci.bat` on Windows. Each must install dependencies, report pytest success, and create `dist/hello.py`.
4. Confirm `dist/hello.py` exists and running it with the corresponding `.venv` Python prints exactly `Hello, World!`.
5. Report individual results and an overall `PASS` only if all required checks pass. When a platform is unavailable, state that its platform-specific script was not run rather than implying it passed.

## If a step fails

- Stop the current script at the first failed operation and preserve its nonzero exit status. In particular, do not copy to `dist/hello.py` if dependency installation or pytest fails.
- Report the failed step, command, exit status, and relevant error output.
- Diagnose the smallest relevant cause, such as missing Python, an invalid scaffold input, dependency installation failure, a failing assertion, or a copy error.
- Correct only files created by this skill or files the user has explicitly authorized you to change. Do not delete unrelated files or clean generated directories to hide a failure.
- Rerun the failed verification after an authorized correction. If blocked by a platform or environment issue, describe the blocker and leave the result as `FAIL` or not verified; do not report success.
