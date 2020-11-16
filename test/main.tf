terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 2.34.0"
  features {}
}

module "akv_test" {
  source            = "../"
  akv_config        = var.akv_config
  resource_group    = azurerm_resource_group.test-RG
  tags              = var.tags
  env               = var.env
  userDefinedString = "testkv"
}