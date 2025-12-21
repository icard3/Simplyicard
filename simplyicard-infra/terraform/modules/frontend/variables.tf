variable "bucket_name" {
  description = "Name of the S3 bucket for the frontend"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}
