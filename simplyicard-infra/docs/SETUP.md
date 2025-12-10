# Project Setup & Workflow Guide

## Prerequisites
- **Git**: Install and configure.
- **GitHub Account**: Access to the `Simplyicard` repository.
- **Terraform** (Optional): Useful for local validation (`terraform validate`), but **deployments are now automated**.


 Do not run `terraform apply` from your local machine anymore. 
All deployments to Anil's Production account are now handled automatically by GitHub Actions.

### How to Contribute (For Everyone)

1.  **Get the Code**:
    ```bash
    git clone https://github.com/icard3/Simplyicard.git
    cd simplyicard-infra
    ```

2.  **Create a Branch**:
    Never push directly to `main`.
    ```bash
    git checkout -b feature/my-new-feature
    ```

3.  **Make Changes**:
    - Edit Terraform files in `terraform/modules/` or `terraform/prod/`.
    - Run `terraform fmt -recursive` to format your code.

4.  **Push & Review**:
    ```bash
    git add .
    git commit -m "Added RDS module"
    git push origin feature/my-new-feature
    ```
    - Go to GitHub and create a **Pull Request (PR)**.
    - **Check the Actions Tab**: GitHub will automatically run `terraform plan` to show you what *would* happen.

5.  **Deploy**:
    - Once the Team Lead approves and merges the PR into `main`, GitHub Actions will populate the changes to the Production AWS account automatically.

## Troubleshooting

### "Multi-Account" Setup
- **Do NOT** use your personal AWS access keys to deploy `prod`.
- The CI/CD pipeline uses a special "OIDC" role (`AWS_ROLE_ARN`) to authenticate securely with Anil's account.

### Local Destruction
If you previously ran `terraform apply` on your personal machine (especially Udayasri), you **MUST** run:
```bash
terraform destroy
```
...using your personal credentials to clean up your own account.
