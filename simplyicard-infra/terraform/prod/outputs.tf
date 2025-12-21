output "cloudfront_url" {
  description = "The domain name of the CloudFront distribution for the frontend"
  value       = "https://${module.frontend.cloudfront_distribution_domain_name}"
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer for the backend API"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS database"
  value       = module.rds.db_endpoint
}
