## [2.2.0] - 2026-08-03

The format from this entry onward follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

### Changed

- Upgraded `azurerm` provider constraint to `~> 5.0` (created `providers.tf`; none existed before —
  resolved to `5.0.1`).
- **Breaking change absorbed:** `azurerm_key_vault.rbac_authorization_enabled` is now Required in
  azurerm `5.0` (was Optional, default `false`). `akv_features.enable_rbac_authorization` now
  defaults to `false` (was `null`) so existing tfvars that omit it keep the same effective plan.
- `output.object` is now marked `sensitive = true` (exposes the full `azurerm_key_vault` resource
  object).
- Fixed `.gitignore`: replaced the stale `test/*` ignore patterns (referencing a directory that no
  longer exists) with the standard template, including `*.tfvars` ignored before the
  `!ESLZ/*.tfvars` negation (previously absent, making that negation a no-op).
- Bumped `actions/checkout` to `v7.0.1` and `terraform-docs/gh-actions` to `v1.4.1` in
  `.github/workflows/documentation.yml`.
- README static usage section rewritten above the `<!-- BEGIN_TF_DOCS -->` marker; the
  `<!-- BEGIN_TF_DOCS -->`/`<!-- END_TF_DOCS -->` block itself regenerated with `terraform-docs`
  now that `providers.tf` exists (previously showed "No requirements").

### Added

- `name` optional input (inside `akv_config`) to override the auto-generated Key Vault name
  (default: `{env4}CKV-{userDefinedString}-{unique}-kv`).
- `soft_delete_retention_days` optional input (azurerm >= 5.0): number of days soft-deleted items
  are retained (`7`-`90`, provider default `90`). Additive with no plan diff when omitted.
- `access_policy` optional input: inline access policies (up to 1024), rendered via a `dynamic`
  block gated on the caller supplying the list. Additive with no plan diff when omitted.
- `lifecycle.precondition` on `azurerm_key_vault.akv` that rejects configurations combining
  `enable_rbac_authorization = true` with inline `access_policy` entries (mutually exclusive in
  Azure).
- `providers.tf`, `.tflint.hcl` (none previously existed).
- `.github/workflows/terraform-ci.yml` and `.github/workflows/release.yml` (release-on-merge,
  tagged from `ESLZ/key_vault.tf`'s own `?ref=`).
- `ESLZ/key_vault.tf` (module block, previously absent) and `ESLZ/key_vault.tfvars` with commented
  examples for every new argument; added missing `variable "env"` and `variable "tags"` declarations
  so `terraform validate` passes in the ESLZ directory.
- `tests/key_vault.tftest.hcl` and `tests/upgrade_compat.tftest.hcl` (no prior test coverage
  existed; 12 runs total, using `override_data` on `data.azurerm_client_config.current` so
  `tenant_id` is a valid UUID under `mock_provider`).

### Known blockers

- None. No module input variables were removed and no resource address changed; existing tfvars
  require no changes (aside from the `rbac_authorization_enabled` default change above, which is
  transparent to callers who already relied on the old `false` default).

## [v2.1.5] and earlier

See git history for changes prior to this entry.
