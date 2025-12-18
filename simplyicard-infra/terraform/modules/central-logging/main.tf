# modules/central-logging/main.tf
resource "aws_kinesis_firehose_delivery_stream" "logs" {
  name        = "central-logs-${var.env}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = var.cross_account_role_arn
    bucket_arn         = var.logs_bucket_arn
    compression_format = "GZIP"
    buffering_size     = 128
    buffering_interval = 300
    prefix             = "${var.env}/service=!{partitionKeyFromQuery:service}/dt=!{timestamp:yyyy/MM/dd}/"
    error_output_prefix = "errors/${var.env}/dt=!{timestamp:yyyy/MM/dd}/"
  }
}

resource "aws_cloudwatch_log_subscription_filter" "to_central" {
  for_each        = toset(var.source_log_groups)
  name            = "to-central-${each.key}"
  log_group_name  = each.value
  destination_arn = aws_kinesis_firehose_delivery_stream.logs.arn
  role_arn        = var.cross_account_role_arn
  filter_pattern  = ""
  distribution    = "ByLogStream"
}