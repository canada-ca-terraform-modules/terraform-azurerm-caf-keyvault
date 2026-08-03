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

# Step 1: simulate a currently-deployed Key Vault (pre-upgrade config, no new args)
run "baseline_apply" {
  command = apply
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
    error_message = "Baseline apply: unexpected resource name"
  }
}

# Step 2: plan the upgraded code (new optional args added) against that state
run "upgrade_plan_no_replacement" {
  command = plan
  variables {
    akv_config = {
      sku_name = "standard"
      akv_features = {
        enable_rbac_authorization = true
      }
      soft_delete_retention_days = 30
    }
  }
  assert {
    condition     = length(regexall("^DevCKV-test-[a-z0-9]{8}-kv$", azurerm_key_vault.akv.name)) == 1
    error_message = "Resource name must be unchanged after upgrade"
  }
  assert {
    condition     = azurerm_key_vault.akv.soft_delete_retention_days == 30
    error_message = "soft_delete_retention_days must be set after upgrade"
  }
}
