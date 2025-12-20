# Enable GuardDuty in the current AWS region
resource "aws_guardduty_detector" "this" {
  enable = true
}
