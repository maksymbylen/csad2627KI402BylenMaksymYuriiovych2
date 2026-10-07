---
name: project-scaffold
description: Use when creating or validating the initial Python project scaffold for project hello, including its Hello World entry point and addition module.
---

# project-scaffold

Create the initial source scaffold using these inputs:

- `language=Python`
- `project_name=hello`

## Files created

- `src/hello.py` prints exactly `Hello, World!` followed by a newline when run as a script.
- `src/add.py` defines a simple `add(a, b)` function that returns `a + b`.

Create the `src/` directory if it does not already exist. Do not add unrelated files as part of this skill.

## Safe, repeatable procedure

1. Inspect `src/`, `src/hello.py`, and `src/add.py` before writing anything.
2. Create only missing directories and files. If a target file already contains the required implementation, leave it unchanged so rerunning the skill is harmless.
3. If a target file exists with different content, do not replace or delete it. Report the conflict and ask for authorization before changing that file. Do not claim the scaffold is complete while a required file remains unresolved.
4. Write `src/hello.py` with:

   ```python
   print("Hello, World!")
   ```

5. Write `src/add.py` with:

   ```python
   def add(a, b):
       return a + b
   ```

## Verification

After creation (or when verifying an existing scaffold):

1. Run `python -m py_compile src/hello.py src/add.py` from the repository root. This checks both files compile.
2. Run `python src/hello.py` and confirm its output is exactly `Hello, World!`.
3. Import `add` from `src/add.py` and verify representative cases, for example `add(2, 3) == 5` and `add(-1, 1) == 0`. If the project has pytest available, these may also be checked through its existing test setup; do not add a test file as part of this scaffold skill.
4. Report each verification result clearly. Report overall success only when all checks pass.

## If validation fails

- Report the failed command or assertion and its error output.
- Fix only files created by this procedure or files the user has explicitly authorized you to change. Preserve unrelated user content and any conflicting pre-existing target file.
- Rerun the failed verification step after an authorized correction. If a conflict or environment problem prevents validation, explain the blocker and report the scaffold as incomplete rather than claiming success.
