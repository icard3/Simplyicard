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
variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
  default     = ""
}
