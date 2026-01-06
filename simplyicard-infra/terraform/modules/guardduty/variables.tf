variable "alarm_topic_arn" {
  description = "SNS topic ARN to send GuardDuty findings to"
  type        = string
  default     = ""
}
