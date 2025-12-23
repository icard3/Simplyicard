variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to associate with the VPN"
  type        = list(string)
}

variable "client_cidr_block" {
  description = "The CIDR block to assign to VPN clients"
  type        = string
  default     = "10.100.0.0/22"
}
