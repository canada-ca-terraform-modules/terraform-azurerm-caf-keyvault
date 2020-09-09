locals {
  env               = "test"
  userDefinedString = "akv"
  location          = "canadacentral"
  resource_groups = {
    test = {
      name     = "test-caf-akv"
      location = "canadacentral"
    },
  }
  tags = {
    environment = "DEV"
    owner       = "CAF"
  }
  akv_config = {
    #akv_features is optional
    akv_features = {
      enabled_for_disk_encryption     = true
      enabled_for_deployment          = true
      enabled_for_template_deployment = true
      soft_delete_enabled             = true
      purge_protection_enabled        = true
    }

    sku_name = "standard"

    #network_acls is optional
    network_acls = {
      # bypass = "AzureServices"
      # default_action = "Deny"
    }
  }
}
