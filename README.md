# Deploys an Azure Key Vault

Creates an Azure Key Vault.

Supported features:

1. AKV main settings: enabled for deployment, disk encryption, template deployment  
2. AKV SKU: Premium or Standard  
3. AKV networks ACL

Non-supported features:

1. Support for AKV policies is kept outside of this module in order to preserve consistency of policies. Ie: for each AKV creation, you should set your access policy tailored to the specific purpose (see AKV sample policy file - access\_policy\_sample.tf)

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

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| akv\_config | Key Vault Configuration Object | `any` | n/a | yes |
| env | You can use a prefix to add to the list of resource groups you want to create | `string` | n/a | yes |
| resource\_group | Resource group object of the AKV to be created | `any` | n/a | yes |
| tags | Tags to be applied to the AKV to be created | `map(string)` | n/a | yes |
| userDefinedString | UserDefinedString part of the name of the resource | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | returns the ID of Azure Key Vault |
| name | returns the name of Azure Key Vault |
| object | returns the full Azure Key Vault Object |
| vault\_uri | returns the vault URI of Azure Key Vault |

