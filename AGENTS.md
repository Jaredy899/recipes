<!--
SPDX-FileCopyrightText: 2025 AerynOS Developers
SPDX-License-Identifier: MPL-2.0
-->

# AGENTS.md

## Cursor Cloud specific instructions

This repo is the **AerynOS `recipes`** monorepo: ~1,700 package build recipes
(`<letter>/<pkg>/stone.yaml`), not a runnable app/service. "Running" the project
means **linting recipes** and (on an AerynOS host only) building them. See
`README.md` and the root `justfile` for the full workflow.

### What can run on this (Ubuntu) VM
- **Recipe lint (the CI `Recipes` job, gating):**
  `python3 tools/CI/package_checks.py --base=origin/main`
  - Needs `python3` + `ruamel.yaml` (installed by the update script).
  - To lint **uncommitted working-tree edits**, add `--untracked`. Gotcha: the flag
    names are swapped internally — `--untracked` = modified tracked files,
    `--modified` = new untracked files.
  - `SPDXLicense` check fetches the SPDX license list over the network; it needs
    egress to `raw.githubusercontent.com` or it will raise.
  - Only **errors** fail (exit 1); warnings pass unless `--fail-on-warnings`.
- **REUSE/SPDX lint (CI `Repository` job):** `just verify-reuse` (= `reuse lint`).
  Currently reports **pre-existing** non-compliance (many package payload files lack
  SPDX headers). This CI job is `continue-on-error: true`, so treat it as
  **non-blocking**; do not try to "fix" the whole tree.
- **`just` task runner** and **git commit hooks** (`just init`).

### What CANNOT run here
Actual package builds/installs need the AerynOS tools **`boulder`** and **`moss`**
(and `ent` for `just updates`), which ship with AerynOS and are **not available on a
generic Ubuntu VM**. So `just build`, `chroot`, `bump`, `index-local`, `mv-local`,
`updates` will not work here. Do not attempt full recipe builds in this environment;
validate recipe changes with the lint above instead.

### Gotchas
- **`just` version:** the repo `justfile` uses `set quiet`, which requires
  `just >= 1.23`. Ubuntu's apt `just` (1.21) is too old; a current `just` binary is
  installed to `/usr/local/bin` (the update script keeps it in place). Do not
  `apt install just` over it.
- **Commit messages** must follow the AerynOS summary format (see `README.md`),
  e.g. `name: Update to v<version>`, `name: Fix <...>`, or
  `[NFC] name: <no-functional-change description>`.
- Never hand-edit generated/binary files (`manifest.x86_64.bin`); manifests are
  produced by `boulder`.
