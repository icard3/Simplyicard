resource "aws_config_configuration_recorder" "main" {
  name     = "simplyicard-config-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.main]
}

resource "aws_config_delivery_channel" "main" {
  name           = "simplyicard-config-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.id
  sns_topic_arn  = var.alarm_topic_arn
}

resource "aws_s3_bucket" "config_bucket" {
  bucket        = "simplyicard-config-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_iam_role" "config_role" {
  name = "simplyicard-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "config.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

data "aws_caller_identity" "current" {}

variable "alarm_topic_arn" {
  description = "SNS topic ARN for delivery channel"
  type        = string
}
