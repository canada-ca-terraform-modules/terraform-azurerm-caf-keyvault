variable "resource_group" {
  description = "Resource group object of the AKV to be created"
  type        = any
}

variable "tags" {
  description = "Tags to be applied to the AKV to be created"
  type        = map(string)
}

variable "akv_config" {
  description = "Key Vault Configuration Object"
  type        = any
}

variable "env" {
  description = "You can use a prefix to add to the list of resource groups you want to create"
  type        = string
}

variable "userDefinedString" {
  description = "UserDefinedString part of the name of the resource"
  type        = string
}
