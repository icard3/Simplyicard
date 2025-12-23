variable "vpc_id" {
  description = "The VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB (not used if internal)"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the internal ALB"
  type        = list(string)
  default     = []
}

variable "vpn_client_cidr_block" {
  description = "CIDR block assigned to VPN clients"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = "" # Optional for now
}
