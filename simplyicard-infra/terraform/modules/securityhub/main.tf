# Enable Security Hub in the account
resource "aws_securityhub_account" "this" {
  auto_enable_controls = true
}

# Always subscribe to AWS Foundational Security Best Practices
resource "aws_securityhub_standards_subscription" "foundational" {
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# Conditionally subscribe to CIS AWS Foundations Benchmark
resource "aws_securityhub_standards_subscription" "cis" {
  count         = var.enable_cis_benchmark ? 1 : 0
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/1.4.0"
}

# Optionally configure delegated admin account for org-wide Security Hub
resource "aws_securityhub_organization_admin_account" "admin" {
  count            = var.delegated_admin_account_id != "" ? 1 : 0
  admin_account_id = var.delegated_admin_account_id
}

# Data source for current region
data "aws_region" "current" {}
