# Developer Guide: Infrastructure Modules

## The "Contract" Approach
To ensure smooth integration, we have **pre-defined the variables and outputs** for all modules (RDS, ECS, etc.).

**What this means:**
- You do NOT need to change `variables.tf` or `prod/main.tf`.
- You ONLY need to implement the logic in your module's `main.tf`.

## How to Work

### 1. ECS Developer
Your module is located at `terraform/modules/ecs`.
- **Inputs Provided**: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `cluster_name`.
- **Your Job**:
    1. Open `terraform/modules/ecs/main.tf`.
    2. Define your resources (`aws_ecs_cluster`, `aws_ecs_service`, etc.).
    3. Use the variables provided (e.g. `var.vpc_id`).
    4. Ensure you export `cluster_id` in `outputs.tf`.

### 2. RDS Developer
Your module is located at `terraform/modules/rds`.
- **Inputs Provided**: `vpc_id`, `private_subnet_ids`, `db_username`, `db_password`.
- **Your Job**:
    1. Open `terraform/modules/rds/main.tf`.
    2. Create `aws_db_instance` and `aws_db_subnet_group`.
    3. Use `var.private_subnet_ids` for the subnet group.

### 3. ALB Developer
Your module is located at `terraform/modules/alb`.
- **Inputs Provided**: `vpc_id`, `public_subnet_ids`.
- **Your Job**:
    1. Create `aws_lb`, `aws_lb_target_group`, `aws_lb_listener`.
    2. Export `alb_dns_name` and `target_group_arn` in `outputs.tf`.

### 4. ECR Developer
Your module is located at `terraform/modules/ecr`.
- **Inputs Provided**: `repository_names` (list).
- **Your Job**:
    1. Use `for_each` to create multiple `aws_ecr_repository` resources.
    2. Export the repository URLs.

### 5. Security Developer (SecurityHub, GuardDuty, Config, CloudTrail)
Your modules are located in `terraform/modules/`.
- **Inputs Provided**: Mostly defaults. `cloudtrail` accepts `s3_bucket_name`.
- **Your Job**:
    1. **Security Hub**: Enable `aws_securityhub_account` and standards.
    2. **GuardDuty**: Enable `aws_guardduty_detector`.
    3. **Config**: Setup `aws_config_configuration_recorder`.
    4. **CloudTrail**: Create `aws_cloudtrail` and the logging S3 bucket.

##  Testing Your Changes

### 1. Local Validation (Syntax Check)
Before pushing, run these commands inside your module folder (e.g. `terraform/modules/ecs`) to ensure your code is syntactically correct:
```bash
terraform init
terraform validate
```
*Note: Do NOT run `terraform plan` here. It will fail because it lacks the production inputs.*

### 2. Remote Verification (Logic Check)
1. Push your branch to GitHub.
2. Open a **Pull Request**.
3. **GitHub Actions** will automatically run `terraform plan` using the production config.
4. Review the "Actions" tab to see exactly what resources will be created.
