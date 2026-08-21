# `test/live/` - live-test harness

A live, real-Azure-resource harness used by the `live-test` PR check (see
the [`live-test-actions`](https://github.com/canada-ca-terraform-modules/live-test-actions)
repo and this module's own `.github/workflows/live-test.yml` once it lands)
to prove that an open PR doesn't destroy or replace a resource a real
consumer already has running. It is **not** a substitute for either of the
module's other two test surfaces:

- **`tests/*.tftest.hcl`** - mock-based unit tests (`terraform test`, no
  provider credentials, no live Azure resources). Covers naming, defaults,
  and validation logic on every PR via `terraform-ci.yml`. Run these first;
  they're fast and free.
- **`ESLZ/`** - a usage example showing the map-based (`for_each`) blueprint
  pattern consumers actually wire this module into. Not exercised by CI at
  all; documentation only.
- **`test/live/`** (this directory) - a single, real instance of the module
  applied against a disposable Azure sandbox subscription. Used by CI to
  diff the PR's plan against a live baseline, and can be run manually by a
  maintainer the same way.

## What's here

| File | Purpose |
|---|---|
| `main.tf` | Module block with `source = "../../"` (a relative path, not a pinned `?ref` - "baseline" and "PR" are just two on-disk checkouts of this repo) and the `azurerm` provider config. |
| `test_dependencies.tf` | A dedicated, throwaway resource group this harness owns outright - never a shared/production resource group. |
| `variables.tf` | `env`, `location` (defaults to `canadacentral`), `tags`, and `akv_config` (typed `any`, passed straight through to the module). |
| `config/key_vault.tfvars` | One representative real-usage fixture: RBAC-auth enabled, `network_acls` with a `Deny` default and an allow-list, no access policies, no `for_each` fan-out. |

No Terragrunt anywhere under this directory - a single harness per repo has
no cross-harness DRY need.

## Running it manually

Requires your own `az login` session against the sandbox subscription (CI
uses OIDC instead - see ticket 09/`verify-live-test-oidc.yml`).

```bash
cd test/live
terraform init
terraform plan  -var-file=config/key_vault.tfvars
terraform apply -var-file=config/key_vault.tfvars
```

Confirm only the live-test resource group and `module.key_vault` are
planned/applied, then tear it down:

```bash
terraform destroy -var-file=config/key_vault.tfvars
```

No `.tfstate` file is ever committed under `test/live/` - every run is
fully ephemeral, whether run by CI or by hand.
