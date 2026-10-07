---
name: github-actions
description: Use when configuring or validating GitHub Actions CI for the cross-platform Python hello project.
---

# github-actions

Configure GitHub Actions CI for the Python project using these input scripts:

- `ci.sh`
- `ci.bat`

The scripts from `build-and-test` are prerequisites. Inspect them before configuring the workflow and confirm that they run tests and create `dist/hello.py` only after tests pass.

## File created

Create `.github/workflows/ci.yml`. The workflow must:

- Run on `push` and `pull_request` targeting `develop` and `master`.
- Use one job with an operating-system matrix containing `ubuntu-latest`, `windows-latest`, and `macos-latest`.
- Check out the repository and set up an appropriate Python version (use Python `3.x` unless the project specifies a supported version).
- Run `ci.bat` on Windows and `ci.sh` on Linux and macOS.
- Upload the resulting `dist/` directory as a build artifact, with a distinct artifact name per operating system and `if-no-files-found: error`.
- The workflow must fail the job and workflow when tests fail; do not continue to artifact upload after a failed CI script.

## Safe, repeatable procedure

1. Inspect the repository and the two input scripts. Do not modify or replace them as part of this skill.
2. Inspect `.github/workflows/ci.yml` if it already exists. Leave a workflow that already meets these requirements unchanged. If it has conflicting content, report the conflict and request authorization before replacing it. Do not delete unrelated workflow files.
3. Create `.github/workflows/` if it does not exist, then add only `ci.yml`.
4. Define `on.push.branches` and `on.pull_request.branches` as `develop` and `master`.
5. Define exactly one job, for example `build`, with `runs-on: ${{ matrix.os }}` and a matrix containing all three required runner labels.
6. In the job steps, use `actions/checkout` and `actions/setup-python`; configure a Python 3 version. Set minimal workflow permissions, such as `contents: read`, and do not pass secrets to the job.
7. Run the matching build script from the repository root: use `ci.bat` with the Windows command shell when `runner.os == 'Windows'`; use `sh ci.sh` on Linux and macOS. Do not mask a nonzero exit status or mark a failed test step as successful.
8. After the CI script succeeds, upload `dist/` using `actions/upload-artifact`. Give each matrix run a unique artifact name such as `hello-${{ runner.os }}` and configure missing files as an error. Do not use `always()` for artifact upload, because a failed test must fail the job without appearing as a successful build.
9. Keep the workflow safe to rerun: avoid cleanup or destructive commands, and only produce artifacts from the checked-out repository's build output. Never print, inject, stage, or commit secrets.

A representative workflow structure is:

```yaml
name: Python CI

on:
  push:
    branches: [develop, master]
  pull_request:
    branches: [develop, master]

permissions:
  contents: read

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: true
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.x'
      - name: Run CI on Windows
        if: runner.os == 'Windows'
        shell: cmd
        run: ci.bat
      - name: Run CI on Linux and macOS
        if: runner.os != 'Windows'
        run: sh ci.sh
      - name: Upload build artifact
        uses: actions/upload-artifact@v4
        with:
          name: hello-${{ runner.os }}
          path: dist/
          if-no-files-found: error
```

## Verification

1. Confirm `.github/workflows/ci.yml` exists and contains both events, both branch names, exactly one matrix job, and all three runner labels.
2. Validate the workflow syntax with `actionlint` when available. If it is unavailable, perform a careful YAML and GitHub Actions structure check and report that the external linter was not run.
3. Confirm checkout, Python setup, platform-specific script selection, and artifact upload are present. Ensure upload occurs after the CI script and missing `dist/` files cause failure.
4. Run the corresponding CI script locally on available platforms and confirm pytest failures return nonzero and do not produce a successful upload path. Do not claim a runner was locally verified when that platform is unavailable.
5. Report each verification result and any platform not tested. Consider the workflow valid only when the required structure and available validation checks pass.

## If the workflow is invalid or fails

- Report the failing validation, GitHub Actions step, runner OS, exit code, and relevant log output.
- For invalid YAML or workflow structure, correct only `.github/workflows/ci.yml` after preserving any unrelated content, then rerun the syntax validation.
- For a failing CI script or test, diagnose the script/test failure first. Do not bypass tests, suppress errors, or upload a missing artifact as a success.
- Check runner-specific command-shell and path behavior when only one operating system fails.
- Never expose or commit secrets while diagnosing. If a failure depends on a secret or external configuration, report the missing prerequisite without printing its value.
- Rerun the failed check after an authorized fix. If validation remains blocked, report the workflow as failed or unverified rather than successful.
