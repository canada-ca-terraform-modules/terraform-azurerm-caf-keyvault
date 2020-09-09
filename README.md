# Deploys an Azure Key Vault

Creates an Azure Key Vault.

Supported features:

1. AKV main settings: enabled for deployment, disk encryption, template deployment
2. AKV SKU: Premium or Standard
3. AKV networks ACL

Non-supported features:

1. Support for AKV policies is kept outside of this module in order to preserve consistency of policies. Ie: for each AKV creation, you should set your access policy tailored to the specific purpose (see AKV sample policy file - access_policy_sample.tf)

Reference the module to a specific version (recommended):

```hcl
module Project-kv {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-keyvault/tree/dev"
  dev = var.dev
  userDefinedString = "${local.group_short}-${local.project_short}"
  resource_group = local.resource_groups.Keyvault-rg
  akv_config = {
    #akv_features is optional
    akv_features = {
        enabled_for_disk_encryption = true
        enabled_for_deployment      = false
        enabled_for_template_deployment = true
        soft_delete_enabled = true
        purge_protection_enabled = true
    }

    sku_name = "standard"
    
    #network_acls is optional
    network_acls = {
         # bypass = "AzureServices"
         # default_action = "Deny"
    }
  }
}
```

## Inputs

| Name                    | Type   | Default | Description                                                                                                                                   |
| ----------------------- | ------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| resource_group     | object | None    | (Required) Resource group object where to create the resource. Changing this forces a new resource to be created.                        |
| tags                    | map    | None    | (Required) Map of tags for the deployment.                                                                                                    |
| log_analytics_workspace | string | None    | (Required) Log Analytics Workspace.                                                                                                           |
| diagnostics_map         | map    | None    | (Required) Map with the diagnostics repository information.                                                                                   |
| diagnostics_settings    | object | None    | (Required) Map with the diagnostics settings. See the required structure in the following example or in the diagnostics module documentation. |
| akv_config              | object | None    | (Required) Key Vault Configuration Object as described in the Parameters section.                                                             |
| convention              | string | None    | (Required) Naming convention to be used (check at the naming convention module for possible values).                                          |
| prefix                  | string | None    | (Optional) Prefix to be used.                                                                                                                 |
| postfix                 | string | None    | (Optional) Postfix to be used.                                                                                                                |
| max_length              | string | None    | (Optional) maximum length to the name of the resource.                                                                                        |

## Parameters
### akv_config

(Required) Key Vault Configuration Object"

```hcl
variable "akv_config" {
  description = "(Required) Key Vault Configuration Object"
}
```

Sample:

```hcl
akv_config = {
    akv_features = {
        enabled_for_disk_encryption = true
        enabled_for_deployment      = false
        enabled_for_template_deployment = true
        soft_delete_enabled = true
        purge_protection_enabled = true
    }
    #akv_features is optional

    sku_name = "premium"
    network_acls = {
         bypass = "AzureServices"
         default_action = "Deny"
    }
    #network_acls is optional
}
```

## Output

| Name      | Type   | Description                                 |
| --------- | ------ | ------------------------------------------- |
| object    | object | Returns the full object of the created AKV. |
| name      | string | Returns the name of the created AKV.        |
| id        | string | Returns the ID of the created AKV.          |
| vault_uri | string | Returns the FQDN of the created AKV.        |
