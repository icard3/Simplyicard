# Team Workflow Guide: Simplyicard Infrastructure

This guide outlines how a **6-person team** can effectively collaborate on this AWS infrastructure project using Terraform and GitHub Actions.

## 1. Team Roles (Recommended for 6 People)

To avoid "too many cooks in the kitchen," divide the team into specialized areas:

*   **1 x Team Lead / DevOps Architect**: Responsible for `prod` merges, OIDC role management, and final verification.
*   **2 x Core Infrastructure Devs**: Focus on `VPC`, `ALB`, and `Networking`.
*   **2 x App & Database Devs**: Focus on `ECS`, `RDS`, and `ECR`.
*   **1 x Security & Compliance Dev**: Focus on `Security Hub`, `GuardDuty`, `Config`, and `CloudTrail`.

## 2. Code Management: The Branching Strategy

**Rule #1: Never push to `main` directly.**

1.  **Branching**: Each dev creates a feature branch:
    ```bash
    git checkout -b feature/your-feature-name
    ```
2.  **Formatting**: Always run this before committing to keep code clean:
    ```bash
    terraform fmt -recursive
    ```
3.  **Pull Requests (PRs)**: One you push, open a PR to `main`.
4.  **Peer Review**: At least **one other person** from your sub-team must approve the PR.

## 3. CI/CD: Automated Validation

We use **GitHub Actions** to prevent breaking the production environment.

*   **The "Plan" Check**: When you open a PR, GitHub runs `terraform plan`.
    *   **How to view**: Go to the **Actions** tab in GitHub. Click on your workflow run.
    *   **What to check**: Look at the "Terraform Plan" step output. It will tell you exactly which resources will be created (+), changed (~), or destroyed (-).
*   **The "Apply" Trigger**: Once the Team Lead merges the PR into `main`, the deployment to AWS happens **automatically**.

## 4. Operational Oversight: "How to know it works?"

As a team, use these tools to verify your work:

### A. Health Checks (ALB/ECS)
*   Check the **Target Group** in the AWS Console. If targets are "Unhealthy," your app container is failing to start or the load balancer cannot reach it.
*   **Common fix**: Check Security Group rules (Port 8080) and Container Environment variables (DB Connection).

### B. Centralized Logging (CloudWatch)
*   Go to **CloudWatch > Log Groups > /ecs/prod-simplyicard-app**.
*   Every developer should keep this open during a deployment to see real-time app errors.

### C. Security Monitoring (Security Hub)
*   The Security Developer should check **Security Hub** weekly.
*   Look for "Critical" or "High" findings. These are often missed IAM permissions or public resources.

### D. Cost Management
*   Enable **AWS Budgets**. A team of 6 can accidentally spawn many expensive resources (like large RDS instances). Stick to the `t3.micro` or `t3.small` instances defined in `prod/main.tf`.

## 5. Environment Replication (Dev & Staging)

To create a **Dev** or **Staging** environment:
1.  Copy the `terraform/prod` folder to `terraform/dev`.
2.  Update the `s3_bucket` in `versions.tf` to a different bucket (or different key).
3.  Change variables like `env = "dev"` to keep logs and resources separate.

---
**Prepared with ❤️ for the Simplyicard Team**
