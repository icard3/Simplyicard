variable "env" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "service_names" {
  description = "List of services to create log groups for"
  type        = list(string)
}

variable "retention_days" {
  description = "Retention in days per service"
  type        = map(number)
  default     = {}
}

variable "alarm_topic_arn" {
  description = "SNS topic ARN for alarms"
  type        = string
}

variable "kms_key_id" {
  description = "Optional KMS key for log encryption"
  type        = string
  default     = null
}
