# Contributing to Simplyicard Infrastructure

Welcome to the team! This guide will help you get started with contributing to our infrastructure.

## Workflow

We follow a standard **Feature Branch Workflow**:

1.  **Clone the Repo**:
    ```bash
    git clone https://github.com/icard3/Simplyicard.git
    cd Simplyicard/simplyicard-infra
    ```

2.  **Create a Branch**:
    Always create a new branch for your work. Do not push directly to `main`.
    ```bash
    git checkout -b feature/my-new-module
    ```

3.  **Make Changes**:
    - Edit the Terraform files in `terraform/modules/` or `terraform/prod/`.
    - Ensure you follow the existing style.

4.  **Format and Validate**:
    Before committing, run:
    ```bash
    terraform fmt -recursive
    terraform validate
    ```

5.  **Commit and Push**:
    ```bash
    git add .
    git commit -m "Add new ECS service"
    git push origin feature/my-new-module
    ```

6.  **Pull Request (PR)**:
    - Open a PR on GitHub.
    - The CI pipeline (`build.yml`) will automatically run checks.
    - Wait for approval from the lead before merging.

## Directory Structure
- `terraform/modules/`: Reusable code. **Edit this to change how resources are created.**
- `terraform/prod/`: The live environment. **Edit this to change parameters (e.g., instance count).**
