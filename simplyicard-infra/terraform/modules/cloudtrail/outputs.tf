output "cloudtrail_id" {
  description = "The name of the trail."
  value       = aws_cloudtrail.main.id
}

output "cloudtrail_arn" {
  description = "The Amazon Resource Name of the trail."
  value       = aws_cloudtrail.main.arn
}

output "logs_bucket_name" {
  description = "The name of the S3 bucket where logs are stored."
  value       = aws_s3_bucket.cloudtrail_logs.id
}
