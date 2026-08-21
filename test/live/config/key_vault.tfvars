# config/key_vault.tfvars
# Tracked, ready-to-run fixture for the test/live harness - one representative
# real-usage instance, not a two-code-path engineered fixture and not a
# dormant "_" template.
#
# Mirrors what an actual landing-zone consumer deploys today: RBAC
# authorization enabled, network_acls with a Deny default and an allow-list,
# no access policies (access_policy and enable_rbac_authorization = true are
# mutually exclusive - see module.tf's lifecycle precondition). No for_each
# fan-out - one instance is enough to prove a breaking-change gate.
#
# Maintained by whoever adds a new optional input to the module: update this
# file in the same PR if you want live coverage of it, same discipline as
# updating tests/key_vault.tftest.hcl.

env = "livetest"

akv_config = {
  sku_name = "standard"

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
