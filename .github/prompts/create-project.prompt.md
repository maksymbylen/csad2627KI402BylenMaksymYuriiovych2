---
name: create-project
description: Create and verify the initial Python hello project source files using the project-scaffold skill.
agent: build-engineer
---

Create the initial Python project structure by invoking or following the instructions in `.github/skills/project-scaffold/SKILL.md`. Load that skill before making project changes and treat it as the authoritative procedure for file contents, safety, and verification.

## Inputs

- `language=Python`
- `project_name=hello`

## Required files

- `src/hello.py`, which prints exactly `Hello, World!` when run.
- `src/add.py`, which defines a simple `add(a, b)` function returning `a + b`.

## Execution rules

1. Follow the skill's inspect-before-write procedure. Create `src/` only if it is missing.
2. Create only the two required source files. Do not delete unrelated user files or change unrelated content.
3. If a required file already has the expected implementation, leave it unchanged. If it contains different content, stop and report a conflict as an error; do not overwrite it without explicit authorization.
4. Keep the operation safe to repeat. Do not report completion while either required file is missing or unresolved.
5. If creation or any validation step fails, stop, report the failed step and relevant error output, and do not claim success.

## Verification and completion

Follow all verification steps in the project-scaffold skill. At minimum:

- Run `python -m py_compile src/hello.py src/add.py` from the repository root.
- Run `python src/hello.py` and confirm standard output is exactly `Hello, World!`.
- Import `add` from `src/add.py` and verify `add(2, 3) == 5` and `add(-1, 1) == 0`.
- Confirm both required files exist and contain the expected implementations.

Report success only after every required check passes. Otherwise report the task as failed or incomplete, identify the failure, and preserve all existing user content.
