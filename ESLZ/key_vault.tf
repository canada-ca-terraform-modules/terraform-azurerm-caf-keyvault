terraform {
  required_version = ">= 1.9"
}

variable "key_vaults" {
  type        = any
  default     = {}
  description = "Map of key_vault objects. Key is used as userDefinedString. See key_vault.tfvars for shape."
}

variable "resource_groups" {
  description = "Map of resource group objects, keyed by name, used to resolve each instance's `resource_group` key."
  type        = any
  default     = {}
}

module "key_vault" {
  for_each = var.key_vaults
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-keyvault?ref=v2.2.0"

  env               = var.env
  userDefinedString = each.key
  resource_group    = var.resource_groups[each.value.resource_group]
  tags              = var.tags
  akv_config        = each.value
}
