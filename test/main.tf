terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }
  required_version = ">= 0.14.1"
}

provider "azurerm" {
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
