variable "vpc_id" {
  description = "The VPC ID where RDS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "simplyicard"
}

variable "vpn_client_cidr_block" {
  description = "CIDR block assigned to VPN clients"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}
