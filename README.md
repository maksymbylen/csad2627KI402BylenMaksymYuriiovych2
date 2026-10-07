# csad2627KI402BylenMaksymYuriiovych2

## Lab 1

Lab 1 for **Automated Design of Computer Systems** builds a small cross-platform Python Hello World project. The custom VS Code Copilot agent, `build-engineer`, automates project setup, testing, build output, and continuous integration while following safe Git practices.

## Goal

Create a Python project with a `Hello, World!` entry point, an addition function and pytest test, Windows and POSIX run/build scripts, and GitHub Actions CI. The build produces `dist/hello.py`; CI runs on Windows, Linux, and macOS.

## Project Layout

The agent configuration is in place. The `init` command creates or verifies the project files shown below, including `src/hello.py`, `src/add.py`, and `.github/workflows/ci.yml`:

```text
.github/
  agents/build-engineer.agent.md
  skills/
    project-scaffold/SKILL.md
    build-and-test/SKILL.md
    github-actions/SKILL.md
  prompts/
    git-init.prompt.md
    create-project.prompt.md
    create-build.prompt.md
    create-actions.prompt.md
    check.prompt.md
    init.prompt.md
  workflows/ci.yml
src/
  hello.py
  add.py
tests/test_basic.py
docs/
requirements.txt
pytest.ini
run.sh
run.bat
ci.sh
ci.bat
.gitignore
README.md
dist/hello.py  (generated build output)
```

## Copilot Commands

Run these workspace prompt commands in order, or use `/init` to orchestrate them:

- `/git-init` prepares Git ignore rules safely.
- `/create-project` creates the initial Python source files.
- `/create-build` configures virtual environment, run scripts, tests, and build scripts.
- `/create-actions` configures GitHub Actions CI.
- `/check` audits the project in read-only mode and reports PASS/FAIL results.
- `/init` runs the full workflow and reports success only when the final check passes.

## Run and Test

From the repository root, run the application with `run.bat` on Windows or `sh run.sh` on Linux/macOS. These scripts set up or reuse `.venv` and install the project dependencies.

Run tests and create the build output with `ci.bat` on Windows or `sh ci.sh` on Linux/macOS. To run pytest directly after setup, use `.venv\Scripts\python.exe -m pytest` on Windows or `.venv/bin/python -m pytest` on Linux/macOS.

GitHub Actions runs the CI scripts on Windows, Linux, and macOS for pushes and pull requests targeting `develop` and `master`, then uploads the build output as an artifact.
