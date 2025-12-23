resource "aws_sns_topic" "alerts" {
  name = "simplyicard-infrastructure-alerts"
}

output "topic_arn" {
  value = aws_sns_topic.alerts.arn
}
