mock_provider "azurerm" {
  override_data {
    target = data.azurerm_client_config.current
    values = {
      tenant_id = "00000000-0000-0000-0000-000000000000"
      object_id = "00000000-0000-0000-0000-0000000000aa"
    }
  }
}

variables {
  resource_group = {
    id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test"
    name     = "rg-test"
    location = "canadacentral"
  }
  tags              = { environment = "test" }
  env               = "Dev"
  userDefinedString = "test"
}

run "naming_convention" {
  command = plan
  variables {
    akv_config = {
      sku_name = "standard"
      akv_features = {
        enable_rbac_authorization = true
      }
    }
  }
  assert {
    condition     = length(regexall("^DevCKV-test-[a-z0-9]{8}-kv$", azurerm_key_vault.akv.name)) == 1
    error_message = "Name must follow {env4}CKV-{userDefinedString}-{unique}-kv convention"
  }
}

run "default_values" {
  command = plan
  variables {
    akv_config = {
      sku_name     = "standard"
      akv_features = {}
    }
  }
  assert {
    # azurerm >= 5.0: rbac_authorization_enabled is Required and cannot be null.
    condition     = azurerm_key_vault.akv.rbac_authorization_enabled == false
    error_message = "rbac_authorization_enabled must default to false when akv_features omits enable_rbac_authorization"
  }
}

run "rbac_enabled" {
  command = plan
  variables {
    akv_config = {
      sku_name = "standard"
      akv_features = {
        enable_rbac_authorization = true
      }
    }
  }
  assert {
    condition     = azurerm_key_vault.akv.rbac_authorization_enabled == true
    error_message = "rbac_authorization_enabled must be true when enable_rbac_authorization = true"
  }
}

run "with_network_acls" {
  command = plan
  variables {
    akv_config = {
      sku_name     = "standard"
      akv_features = {}
      network_acls = {
        default_action = "Deny"
        bypass         = "AzureServices"
        ip_rules       = ["203.0.113.0/24"]
      }
    }
  }
  assert {
    condition     = azurerm_key_vault.akv.network_acls[0].default_action == "Deny"
    error_message = "network_acls block must render when supplied"
  }
}

run "network_acls_bypass_defaults_to_azureservices" {
  command = plan
  variables {
    akv_config = {
      sku_name     = "standard"
      akv_features = {}
      network_acls = {
        default_action = "Deny"
      }
    }
  }
  assert {
    condition     = azurerm_key_vault.akv.network_acls[0].bypass == "AzureServices"
    error_message = "network_acls.bypass must default to AzureServices when omitted"
  }
}

run "no_network_acls" {
  command = plan
  variables {
    akv_config = {
      sku_name     = "standard"
      akv_features = {}
    }
  }
  assert {
    condition     = length(azurerm_key_vault.akv.network_acls) == 0
    error_message = "network_acls block must be omitted when not supplied"
  }
}

run "with_access_policy" {
  command = plan
  variables {
    akv_config = {
      sku_name     = "standard"
      akv_features = { enable_rbac_authorization = false }
      access_policy = [
        {
          object_id          = "11111111-1111-1111-1111-111111111111"
          key_permissions    = ["Get", "List"]
          secret_permissions = ["Get", "List"]
        }
      ]
    }
  }
  assert {
    condition     = length(azurerm_key_vault.akv.access_policy) == 1
    error_message = "access_policy block must render when supplied"
  }
  assert {
    condition     = azurerm_key_vault.akv.access_policy[0].object_id == "11111111-1111-1111-1111-111111111111"
    error_message = "access_policy object_id must be passed through"
  }
}

run "no_access_policy" {
  # command = apply: azurerm_key_vault.access_policy is Optional+Computed (it can also be managed
  # via the standalone azurerm_key_vault_access_policy resource), so its value is unknown at plan
  # time when the dynamic block emits zero entries.
  command = apply
  variables {
    akv_config = {
      sku_name     = "standard"
      akv_features = {}
    }
  }
  assert {
    condition     = length(azurerm_key_vault.akv.access_policy) == 0
    error_message = "access_policy must default to empty when not supplied"
  }
}

run "soft_delete_retention_days" {
  command = plan
  variables {
    akv_config = {
      sku_name                   = "standard"
      akv_features               = {}
      soft_delete_retention_days = 30
    }
  }
  assert {
    condition     = azurerm_key_vault.akv.soft_delete_retention_days == 30
    error_message = "soft_delete_retention_days must be passed through"
  }
}

run "custom_name_override" {
  command = plan
  variables {
    akv_config = {
      name         = "my-existing-kv"
      sku_name     = "standard"
      akv_features = {}
    }
  }
  assert {
    condition     = azurerm_key_vault.akv.name == "my-existing-kv"
    error_message = "name override must be applied"
  }
}

run "rbac_with_access_policy_rejected" {
  command         = plan
  expect_failures = [azurerm_key_vault.akv]
  variables {
    akv_config = {
      sku_name     = "standard"
      akv_features = { enable_rbac_authorization = true }
      access_policy = [
        {
          object_id       = "11111111-1111-1111-1111-111111111111"
          key_permissions = ["Get"]
        }
      ]
    }
  }
}

run "soft_delete_retention_days_out_of_range_rejected" {
  command         = plan
  expect_failures = [azurerm_key_vault.akv]
  variables {
    akv_config = {
      sku_name                   = "standard"
      akv_features               = {}
      soft_delete_retention_days = 6
    }
  }
}

