# Design Decisions

## Infrastructure
- **IaC Tool**: Terraform
- **State Management**: S3 + DynamoDB
- **Container Orchestration**: ECS (EC2 Launch Type)
- **Database**: RDS
- **Load Balancer**: ALB

## Security
- CloudTrail for auditing
- GuardDuty for threat detection
- AWS Config for compliance
- Security Hub for centralized view
