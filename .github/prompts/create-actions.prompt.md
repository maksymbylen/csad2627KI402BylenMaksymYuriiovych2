---
name: create-actions
description: Configure and verify the Python hello project's cross-platform GitHub Actions workflow using the github-actions skill.
agent: build-engineer
---

Configure GitHub Actions CI by invoking or following `.github/skills/github-actions/SKILL.md`. Load that skill before making changes and treat its workflow design, safety rules, and verification steps as authoritative.

## Inputs

Use the existing build scripts:

- `ci.sh`
- `ci.bat`

Inspect and validate them as directed by the skill. Do not modify or replace these input scripts as part of this command.

## Required output

Create or update only `.github/workflows/ci.yml`, following the skill. The workflow must:

- Run on both `push` and `pull_request` for branches `develop` and `master`.
- Use exactly one job with a matrix containing `ubuntu-latest`, `windows-latest`, and `macos-latest`.
- Check out the repository and set up an appropriate Python version.
- Run `ci.bat` on Windows and `ci.sh` on Linux and macOS.
- Upload `dist/` as a build artifact after the CI script succeeds.
- Fail the workflow when tests fail; never mask script failures or upload a failed build as success.
- Avoid exposing or committing secrets.

## Execution rules

1. Inspect the input scripts and `.github/workflows/ci.yml` before writing. Preserve unrelated files; do not delete any user files.
2. Create the workflow directory if needed. Create or update only `ci.yml`; keep the operation safe to repeat and avoid cleanup or destructive commands.
3. Follow the skill's conflict policy. If an existing workflow conflicts and cannot be safely reconciled, stop and report the conflict rather than overwriting it blindly.
4. Do not add secrets or print secret values. Use only the minimal workflow permissions required.
5. If creation or any validation step fails, stop, report the failed step and relevant error output, and do not claim success.

## Verification and completion

Follow all verification steps in the `github-actions` skill. At minimum:

- Confirm `.github/workflows/ci.yml` exists and its YAML is structurally valid. Use `actionlint` when available; otherwise perform the skill's structural validation and report that the external linter was unavailable.
- Verify the workflow includes both `push` and `pull_request`, each restricted to `develop` and `master`.
- Verify there is exactly one matrix job and it includes all three required OS labels: `ubuntu-latest`, `windows-latest`, and `macos-latest`.
- Verify checkout, Python setup, the Windows `ci.bat` step, the Linux/macOS `ci.sh` step, and upload of `dist/` as an artifact. Confirm upload occurs after the CI scripts and missing artifacts are treated as failure.
- Run the relevant CI script locally when possible. Report unavailable platforms as not tested; do not imply they passed.

Report success only after the workflow exists and required structural checks pass. If any required creation or validation step fails, stop and report failure or incomplete status with the reason.
