# TODO: Define environment-specific variables here

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "vpn_client_cidr_block" {
  description = "CIDR block assigned to VPN clients"
  type        = string
  default     = "10.100.0.0/22"
}
