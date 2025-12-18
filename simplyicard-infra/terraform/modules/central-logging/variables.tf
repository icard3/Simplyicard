# modules/central-logging/variables.tf
variable "env" {
  description = "Environment name"
  type        = string
}

variable "logs_bucket_arn" {
  description = "Destination S3 bucket ARN for central logs"
  type        = string
}

variable "cross_account_role_arn" {
  description = "Role ARN in logging account to allow subscription filters"
  type        = string
}

variable "source_log_groups" {
  description = "List of log group names to forward"
  type        = list(string)
}