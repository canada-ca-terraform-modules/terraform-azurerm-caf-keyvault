# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# Deliberately NOT reusing any shared/production resource group: writing into
# a shared RG usually requires elevated, non-sandbox permissions. A dedicated
# throwaway RG here needs only Contributor on the sandbox subscription and
# can never collide with or affect any production resource.
#
# terraform-azurerm-caf-keyvault does not consume a virtual_network/subnet
# directly (network_acls.virtual_network_subnet_ids is left empty in the
# tracked fixture) - no vnet dependency is created here.

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group (or, via the module's own
  # resource_group.id-derived naming, the same Key Vault name).
  name     = "${var.env}-caf-keyvault-live-test-${var.pr_number}-rg"
  location = var.location
}

locals {
  # terraform-azurerm-caf-keyvault expects resource_group.{id,name,location} -
  # a flat object, not a purpose-keyed map.
  resource_group = {
    id       = azurerm_resource_group.live_test.id
    name     = azurerm_resource_group.live_test.name
    location = azurerm_resource_group.live_test.location
  }
}
