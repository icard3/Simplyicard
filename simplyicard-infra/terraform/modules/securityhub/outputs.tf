output "security_hub_arn" {
  description = "The ARN of the Security Hub account."
  value       = aws_securityhub_account.main.id # In some providers id is the hub arn
}
