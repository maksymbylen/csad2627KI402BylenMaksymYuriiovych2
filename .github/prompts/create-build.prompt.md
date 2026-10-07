---
name: create-build
description: Set up and verify the Python hello project's virtual environment, run scripts, tests, and CI build using the build-and-test skill.
agent: build-engineer
---

Set up the Python build, run, and test workflow by invoking or following `.github/skills/build-and-test/SKILL.md`. Load that skill before making changes and treat its procedure as authoritative for file contents, virtual-environment use, safety, and verification.

## Inputs

Use the existing source files:

- `src/hello.py`
- `src/add.py`

Validate these inputs as described by the skill. Do not recreate or modify them as part of this command.

## Required outputs

Create or update only the following files, following the skill:

- `requirements.txt` with pytest as a dependency.
- `pytest.ini` configured for `tests/` and imports from `src/`.
- `run.sh` and `run.bat` to run the Hello World program.
- `tests/test_basic.py` containing a test named exactly `test_basic_addition`.
- `ci.sh` and `ci.bat` to set up or reuse `.venv`, install dependencies, run tests, and produce `dist/hello.py` only after tests pass.

## Execution rules

1. Inspect the input files and every output path before writing. Preserve unrelated user files and content; do not delete unrelated files.
2. Create missing target files and update only the listed targets as needed. Keep repeated runs safe and avoid destructive cleanup. Follow the skill's conflict handling: if a target contains conflicting content that cannot be safely reconciled, stop and report the conflict instead of overwriting blindly.
3. Use `.venv` and install pytest through `requirements.txt`. Scripts must use the virtual environment's Python directly and stop with a nonzero result when a command fails.
4. In both CI scripts, run pytest before creating or refreshing `dist/hello.py`. If dependency installation or tests fail, stop immediately and do not copy the build output.
5. If any required creation, installation, build, or validation step fails, stop, report the failed step, command, exit status, and relevant error output. Do not continue as though setup succeeded.

## Verification and completion

Follow all verification steps in the `build-and-test` skill. At minimum:

- Confirm both input files are valid and all seven required output files exist: `requirements.txt`, `pytest.ini`, `run.sh`, `run.bat`, `tests/test_basic.py`, `ci.sh`, and `ci.bat`.
- Confirm `requirements.txt` installs pytest and the test file defines `test_basic_addition`.
- Run the platform-appropriate run and CI scripts on the available operating system. Confirm the run script prints exactly `Hello, World!`, pytest passes, and `dist/hello.py` exists and prints exactly `Hello, World!`.
- State clearly when a platform-specific script could not be run; do not claim unverified platforms passed.
- Report success only after required files and all checks available on the current platform are verified. Otherwise report failure or incomplete status, with the reason.
