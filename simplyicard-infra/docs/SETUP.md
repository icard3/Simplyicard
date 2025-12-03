# Project Setup Guide

## Prerequisites
- **AWS CLI**: Install and configure with your aws credentials (`aws configure`).
- **Terraform**: Install (v1.0+).
- **Git**: Install.

## 1. Initial Setup (One-Time Only)
**Who will run this?** The team member with AWS Admin access 

To enable Terraform to store its state securely, we need an S3 bucket and DynamoDB table.
1.  **Clone the repo** (if not already done).
2.  Navigate to `terraform/bootstrap/`.
3.  Run `terraform init`.
4.  Run `terraform apply`.
    -IMPORTANT DO NOT SKIP
    - It will create the S3 bucket and DynamoDB table in AWS.
5.  **Check Outputs**:
    - After the command finishes, it will show the `s3_bucket_name` and `dynamodb_table_name` in the terminal.
6.  **Update Configuration**:
    - Open `terraform/prod/backend.tf`.
    - Check if the `bucket` and `dynamodb_table` values match what you just saw in the terminal.
    - If they are different, update the file to match the real values.
    - Commit and push the changes to GitHub.

## 2. Working with Production
1. Navigate to the production directory:
   ```bash
   cd terraform/prod
   ```
2. Initialize Terraform (this downloads providers and connects to the backend):
   ```bash
   terraform init
   ```
3. Check what will be created:
   ```bash
   terraform plan
   ```
4. Apply changes (only if you are sure!):
   ```bash
   terraform apply
   ```

