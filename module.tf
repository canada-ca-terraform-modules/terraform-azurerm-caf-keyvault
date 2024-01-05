locals {
  env_4                     = substr(var.env, 0, 4)
  name-regex                = "/[^0-9A-Za-z-]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  unique_Keyvault           = substr(sha1(var.resource_group.id), 0, 8)
  userDefinedString-replace = replace(var.userDefinedString, "_", "-")
  name-kv-16                = substr("${local.env_4}CKV-${local.userDefinedString-replace}", 0, 16)
  name-kv-21                = substr("${local.name-kv-16}-${local.unique_Keyvault}", 0, 21)
  name-kv-result            = replace("${local.name-kv-21}-kv", local.name-regex, "")
}

resource "azurerm_key_vault" "akv" {
  name                = local.name-kv-result
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
  sku_name            = var.akv_config.sku_name

  enabled_for_disk_encryption     = try(var.akv_config.akv_features.enabled_for_disk_encryption, null)
  enabled_for_deployment          = try(var.akv_config.akv_features.enabled_for_deployment, null)
  enabled_for_template_deployment = try(var.akv_config.akv_features.enabled_for_template_deployment, null)
  purge_protection_enabled        = try(var.akv_config.akv_features.purge_protection_enabled, null)
  public_network_access_enabled   = try(var.akv_config.akv_features.public_network_access_enabled, false)

  dynamic "network_acls" {
    for_each = try(var.akv_config.network_acls, {}) != {} ? [1] : []

    content {
      default_action             = try(var.akv_config.network_aclsdefault_action, null)
      bypass                     = try(var.akv_config.network_aclsbypass, null)
      ip_rules                   = try(var.akv_config.network_aclsip_rules, null)
      virtual_network_subnet_ids = try(var.akv_config.network_aclsvirtual_network_subnet_ids, null)
    }
  }
}
