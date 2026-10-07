# Usage

This project is managed by the `build-engineer` agent workflow.

## Run the full workflow

Use the `/init` command in the workspace to run the full setup flow in order:

- `/init`

This orchestrates the Git safety check, project scaffold, build/test setup, CI configuration, and final verification.

## Run the audit

Use the `/check` command to run the read-only project audit and review the PASS/FAIL results.

## Run the project

### Windows

```powershell
python dist\hello.py
```

### Linux/macOS

```bash
python3 dist/hello.py
```

The generated build output is `dist/hello.py` and it prints `Hello, World!` when run successfully.

## Run tests

### Windows

```powershell
.venv\Scripts\python -m pytest -v
```

### Linux/macOS

```bash
.venv/bin/python -m pytest -v
```

## Run the local CI build

### Windows

```powershell
.\ci.bat
```

### Linux/macOS

```bash
./ci.sh
```

These scripts create or reuse the local virtual environment, install dependencies, run pytest, and produce the build output in `dist/hello.py` only after tests pass.

## GitHub Actions

The project CI runs on Windows, Linux, and macOS via GitHub Actions, using the same build logic defined in the repository scripts.
