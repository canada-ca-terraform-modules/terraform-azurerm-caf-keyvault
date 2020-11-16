variable "location" {
  description = "Location of the network"
  default     = "canadacentral"
}

variable "tags" {
  default = {
    "Organizations"     = "PwP0-CCC-E&O"
    "DeploymentVersion" = "2018-12-14-01"
    "Classification"    = "Unclassified"
    "Enviroment"        = "Sandbox"
    "CostCenter"        = "PwP0-EA"
    "Owner"             = "cloudteam@tpsgc-pwgsc.gc.ca"
  }
}

variable "env" {
  default = "ScTc"
}

variable "akv_config" {
  default = {
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