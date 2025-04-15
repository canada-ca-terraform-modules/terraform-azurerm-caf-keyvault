# Deploys an Azure Key Vault

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

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
