## No variables required for basic enablement
variable "enable_cis_benchmark" {
  description = "Enable CIS AWS Foundations Benchmark standard in SecurityHub"
  type        = bool
  default     = true
}

variable "delegated_admin_account_id" {
  description = "Delegated SecurityHub admin account ID"
  type        = string
  default     = ""
}
