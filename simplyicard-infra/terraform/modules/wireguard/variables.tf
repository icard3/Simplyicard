variable "vpc_id" {
  description = "VPC ID where WireGuard server will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID for WireGuard server"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block for routing"
  type        = string
}

variable "wireguard_cidr" {
  description = "CIDR block for WireGuard VPN clients"
  type        = string
  default     = "10.100.0.0/24"
}

variable "num_clients" {
  description = "Number of client configurations to generate"
  type        = number
  default     = 3
}
