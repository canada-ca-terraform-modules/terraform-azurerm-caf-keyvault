resource "azurerm_resource_group" "test-RG" {
  name     = "test-${local.template_name}-rg"
  location = var.location
}
