locals {
  env_4                     = substr(var.env, 0, 4)
  name-regex                = "/[^0-9A-Za-z-]/" # Anti-pattern to match all characters not in: 0-9 a-z A-Z -
  unique_Keyvault           = substr(sha1(var.resource_group.id), 0, 8)
  userDefinedString-replace = replace(var.userDefinedString, "_", "-")
  name-kv-16                = substr("${local.env_4}CKV-${local.userDefinedString-replace}", 0, 16)
  name-kv-21                = substr("${local.name-kv-16}-${local.unique_Keyvault}", 0, 21)
  name-kv-result            = replace("${local.name-kv-21}-kv", local.name-regex, "")
  name-kv-remove-doubledash = replace(local.name-kv-result, "--", "-")

  # azurerm >= 5.0: access_policy is an optional list of objects (up to 1024). Caller may omit it entirely.
  access_policies = try(var.akv_config.access_policy, [])
}

resource "azurerm_key_vault" "akv" {
  # Optional: override the auto-generated name (default: {env4}CKV-{userDefinedString}-{unique}-kv)
  name                = try(var.akv_config.name, local.name-kv-remove-doubledash)
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
  sku_name            = var.akv_config.sku_name

  enabled_for_disk_encryption     = lookup(var.akv_config.akv_features, "enabled_for_disk_encryption", null)
  enabled_for_deployment          = lookup(var.akv_config.akv_features, "enabled_for_deployment", null)
  enabled_for_template_deployment = lookup(var.akv_config.akv_features, "enabled_for_template_deployment", null)
  # azurerm >= 5.0: rbac_authorization_enabled is now Required (was Optional, default false) - default preserved as false
  rbac_authorization_enabled    = lookup(var.akv_config.akv_features, "enable_rbac_authorization", false)
  purge_protection_enabled      = lookup(var.akv_config.akv_features, "purge_protection_enabled", null)
  public_network_access_enabled = lookup(var.akv_config.akv_features, "public_network_access_enabled", false)
  # New (optional): number of days that soft-deleted items are retained (7-90, default 90). Can only be configured once.
  soft_delete_retention_days = try(var.akv_config.soft_delete_retention_days, null)

  dynamic "network_acls" {
    for_each = lookup(var.akv_config, "network_acls", {}) != {} ? [1] : []

    content {
      default_action             = lookup(var.akv_config.network_acls, "default_action", null)
      bypass                     = lookup(var.akv_config.network_acls, "bypass", null)
      ip_rules                   = lookup(var.akv_config.network_acls, "ip_rules", null)
      virtual_network_subnet_ids = lookup(var.akv_config.network_acls, "virtual_network_subnet_ids", null)
    }
  }

  # New (optional): inline access policies. Up to 1024 entries. Mutually exclusive with
  # enable_rbac_authorization = true (enforced by the lifecycle precondition below), and also
  # mutually exclusive with managing the same object_id via the standalone
  # azurerm_key_vault_access_policy resource.
  dynamic "access_policy" {
    for_each = local.access_policies

    content {
      tenant_id               = try(access_policy.value.tenant_id, data.azurerm_client_config.current.tenant_id)
      object_id               = access_policy.value.object_id
      application_id          = try(access_policy.value.application_id, null)
      certificate_permissions = try(access_policy.value.certificate_permissions, null)
      key_permissions         = try(access_policy.value.key_permissions, null)
      secret_permissions      = try(access_policy.value.secret_permissions, null)
      storage_permissions     = try(access_policy.value.storage_permissions, null)
    }
  }

  lifecycle {
    precondition {
      condition     = !(lookup(var.akv_config.akv_features, "enable_rbac_authorization", false) == true && length(local.access_policies) > 0)
      error_message = "access_policy blocks cannot be used when enable_rbac_authorization = true. Use Azure RBAC role assignments instead."
    }
  }
}
