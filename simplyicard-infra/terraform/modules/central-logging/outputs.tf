# modules/central-logging/outputs.tf
output "firehose_arn" {
  value = aws_kinesis_firehose_delivery_stream.logs.arn
}

output "subscription_filter_ids" {
  value = [for f in aws_cloudwatch_log_subscription_filter.to_central : f.id]
}