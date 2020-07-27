provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_test" {
  name     = local.resource_groups.test.name
  location = local.resource_groups.test.location
  tags     = local.tags
}

module "akv_test" {
  source            = "../../"
  akv_config        = local.akv_config
  resource_group    = azurerm_resource_group.rg_test
  tags              = local.tags
  env               = local.env
  userDefinedString = local.userDefinedString
}
