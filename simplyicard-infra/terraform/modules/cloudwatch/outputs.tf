# modules/cloudwatch/outputs.tf
output "log_group_names" {
  value = { for k, v in aws_cloudwatch_log_group.service : k => v.name }
}

output "alarm_arns" {
  value = {
    alb_5xx = aws_cloudwatch_metric_alarm.alb_5xx_alarm.arn
  }
}