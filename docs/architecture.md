# Project Architecture

## Agent and Workflow

The `build-engineer` VS Code Copilot agent automates creation and verification of a small cross-platform Python Hello World project. Its manifest, [.github/agents/build-engineer.agent.md](../.github/agents/build-engineer.agent.md), defines its role, scope, safety rules, available skills and commands, and completion criteria.

Skills provide focused implementation guidance:

- `project-scaffold` creates `src/hello.py` and `src/add.py`.
- `build-and-test` configures the virtual environment, run scripts, pytest, and build scripts.
- `github-actions` configures and validates continuous integration.

Workspace prompt commands expose those workflows as discrete operations:

- `git-init` prepares Git and `.gitignore` safely.
- `create-project` applies `project-scaffold`.
- `create-build` applies `build-and-test`.
- `create-actions` applies `github-actions`.
- `check` audits the project in read-only mode and reports individual `PASS` or `FAIL` results.
- `init` orchestrates all steps in order:

  `git-init -> create-project -> create-build -> create-actions -> check`

`init` stops on the first error and reports overall success only when the final `check` returns `PASSED`.

## Expected Python Project

The workflow creates or verifies this project structure:

```text
src/hello.py             Hello World entry point
src/add.py               Addition function
 tests/test_basic.py     pytest coverage for test_basic_addition
requirements.txt         pytest dependency
pytest.ini               pytest discovery and source import configuration
.venv/                   Local Python virtual environment
run.sh, run.bat          Platform-specific run scripts
ci.sh, ci.bat            Test and build scripts
dist/hello.py            Generated build output
.github/workflows/ci.yml GitHub Actions workflow
docs/                    Project documentation
```

The run scripts launch `src/hello.py`. The CI scripts use `.venv`, install dependencies, run pytest, and copy `src/hello.py` to `dist/hello.py` only after tests pass.

## Continuous Integration

The workflow in `.github/workflows/ci.yml` runs for pushes and pull requests targeting `develop` and `master`. One matrix job covers `ubuntu-latest`, `windows-latest`, and `macos-latest`: Windows runs `ci.bat`, while Linux and macOS run `ci.sh`. Successful builds upload `dist/` as an artifact; a failed test fails the workflow.

## Safety

The agent preserves existing user content and does not delete user files, rewrite Git history, or commit secrets. Commands are designed to be safe to rerun. `check` does not modify project files and reports each verification as `PASS` or `FAIL`; it returns `PASSED` only when all required checks pass.
