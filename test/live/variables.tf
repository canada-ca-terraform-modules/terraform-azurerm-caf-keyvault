variable "env" {
  description = "Environment prefix used in the generated Key Vault name"
  type        = string
  default     = "livetest"
}

variable "location" {
  description = "Location for the throwaway live-test resource group"
  type        = string
  default     = "canadacentral"
}

variable "tags" {
  description = "Tags applied to the Key Vault created by this harness"
  type        = map(string)
  default = {
    purpose = "module-live-test"
  }
}

variable "akv_config" {
  description = "Key Vault configuration object, passed straight through to the module under test"
  type        = any
}
