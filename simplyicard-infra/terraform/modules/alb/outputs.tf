output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = "aws_lb.alb.dns_name"
}

output "alb_zone_id" {
  description = "The Zone ID of the ALB"
  value       = "aws_lb.alb.zone_id" # Placeholder
}

output "target_group_arn" {
  description = "ARN of the default target group"
  value       = "aws_lb_target_group.tg.arn" # Placeholder
}
# - alb_dns_name
# - target_group_arn
