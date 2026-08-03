# Deploys an Azure Key Vault

Requires the `azurerm` provider `~> 5.0`.

Reference the module to a specific version (recommended):

```hcl
module "key_vault" {
  source             = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-keyvault?ref=v2.2.0"
  userDefinedString  = "${var.group}_${var.project}"
  resource_group     = azurerm_resource_group.example
  tags               = var.tags
  env                = var.env

  akv_config = {
    sku_name = "standard"
    akv_features = {
      enable_rbac_authorization = true
    }
  }
}
```

### ESLZ module block (`ESLZ/key_vault.tf`)

See [`ESLZ/key_vault.tf`](ESLZ/key_vault.tf) and [`ESLZ/key_vault.tfvars`](ESLZ/key_vault.tfvars)
for the map-based (`for_each`) L2 blueprint pattern.

## New optional arguments (azurerm >= 5.0)

| Key | Type | Description |
|---|---|---|
| `name` | string | Override the auto-generated Key Vault name (default: `{env4}CKV-{userDefinedString}-{unique}-kv`) |
| `soft_delete_retention_days` | number | Number of days that soft-deleted items are retained (`7`-`90`, provider default `90`). Can only be configured once |
| `access_policy` | list(object) | Inline access policies (up to 1024). Mutually exclusive with managing the same `object_id` via the standalone `azurerm_key_vault_access_policy` resource |

See [`ESLZ/key_vault.tfvars`](ESLZ/key_vault.tfvars) for full commented examples.

> **Breaking change absorbed:** `akv_features.enable_rbac_authorization` now maps to the
> provider's `rbac_authorization_enabled` argument, which became **Required** in azurerm `5.0`
> (previously Optional, default `false`). This module preserves the old default by falling back
> to `false` when `enable_rbac_authorization` is omitted from `akv_features` — no caller changes
> required.

## Testing

```bash
terraform fmt -recursive && terraform init -backend=false && terraform validate && terraform test
```

## CI

GitHub Actions workflow at `.github/workflows/terraform-ci.yml` runs fmt, init, validate, test, and tflint on every PR.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.akv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_akv_config"></a> [akv\_config](#input\_akv\_config) | Key Vault Configuration Object | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | You can use a prefix to add to the list of resource groups you want to create | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group object of the AKV to be created | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the AKV to be created | `map(string)` | n/a | yes |
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | UserDefinedString part of the name of the resource | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | returns the ID of Azure Key Vault |
| <a name="output_name"></a> [name](#output\_name) | returns the name of Azure Key Vault |
| <a name="output_object"></a> [object](#output\_object) | returns the full Azure Key Vault Object |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | returns the vault URI of Azure Key Vault |
<!-- END_TF_DOCS -->
