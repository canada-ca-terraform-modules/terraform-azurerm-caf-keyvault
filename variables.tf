variable "resource_group" {
  description = "(Required) Resource group object of the AKV to be created"
}

variable "tags" {
  description = "(Required) Tags to be applied to the AKV to be created"
}

variable "akv_config" {
  description = "(Required) Key Vault Configuration Object"
}

variable "env" {
  description = "(Required) You can use a env to the name of the resource"
  type        = string
  default     = ""
}

variable "userDefinedString" {
  description = "(Required) UserDefinedString part of the name of the resource"
  type        = string
  default     = ""
}
