# Rules: existing entries unchanged; new args go below, commented out with explanation
key_vaults = {
  # --- EXISTING ENTRY SHAPE (unchanged) ---
  myKeyVault = {
    resource_group = "existing-rg"
    sku_name       = "standard"

    akv_features = {
      enabled_for_disk_encryption     = true
      enabled_for_deployment          = false
      enabled_for_template_deployment = false
      enable_rbac_authorization       = true
      purge_protection_enabled        = false
      public_network_access_enabled   = true
    }

    network_acls = {
      default_action             = "Deny"
      bypass                     = "AzureServices"
      ip_rules                   = ["203.0.113.0/24"]
      virtual_network_subnet_ids = []
    }
  }

  # --- NEW ARGUMENT EXAMPLES (commented out) ---
  # example_with_new_features = {
  #   resource_group = "rg-example"
  #
  #   # Optional: override the auto-generated name (default: {env4}CKV-{userDefinedString}-{unique}-kv)
  #   name = "existing-prod-kv-name"
  #
  #   sku_name = "standard"
  #
  #   akv_features = {
  #     enable_rbac_authorization = false
  #   }
  #
  #   # New in azurerm >= 5.0 (optional): number of days soft-deleted items are retained (7-90).
  #   # Can only be configured once.
  #   soft_delete_retention_days = 90
  #
  #   # New (optional): inline access policies (up to 1024). Only valid when
  #   # akv_features.enable_rbac_authorization = false.
  #   access_policy = [
  #     {
  #       object_id          = "00000000-0000-0000-0000-000000000000"
  #       key_permissions    = ["Get", "List"]
  #       secret_permissions = ["Get", "List"]
  #     }
  #   ]
  #
  #   # Optional: per-resource tags merged with the base var.tags.
  #   # These take precedence over base tags for the same key.
  #   tags = {
  #     Application = "MyApp"
  #     CostCenter  = "12345"
  #   }
  # }
}
