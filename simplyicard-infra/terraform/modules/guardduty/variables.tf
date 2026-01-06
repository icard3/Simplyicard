variable "alarm_topic_arn" {
  description = "SNS topic ARN to send GuardDuty findings to"
  type        = string
  default     = ""
}

variable "enable_alarms" {
  description = "Enable CloudWatch Alarms/Events for GuardDuty"
  type        = bool
  default     = false
}
