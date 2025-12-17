# modules/cloudwatch/main.tf
resource "aws_cloudwatch_log_group" "service" {
  for_each          = toset(var.service_names)
  name              = "/app/${each.value}/${var.env}"
  retention_in_days = lookup(var.retention_days, each.value, 90)
  kms_key_id        = var.kms_key_id
}

# Example metric filter: ALB 5xx errors
resource "aws_cloudwatch_log_metric_filter" "alb_5xx" {
  name           = "alb-5xx-${var.env}"
  log_group_name = aws_cloudwatch_log_group.service[each.key].name
  pattern        = "{ ($.elb_status_code = 5*) }"

  metric_transformation {
    name      = "ALB5XXCount"
    namespace = "Simplyicard/ALB"
    value     = "1"
  }
}

# Example alarm: ALB 5xx surge
resource "aws_cloudwatch_metric_alarm" "alb_5xx_alarm" {
  alarm_name          = "alb-5xx-high-${var.env}"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  dimensions          = { LoadBalancer = "simplyicard-alb" }
  comparison_operator = "GreaterThanThreshold"
  threshold           = 50
  period              = 60
  evaluation_periods  = 3
  statistic           = "Sum"
  alarm_actions       = [var.alarm_topic_arn]
}