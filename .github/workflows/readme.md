# Terraform CI/CD Pipeline Explanation

This GitHub Actions workflow automates Terraform infrastructure deployment with proper AWS authentication and follows DevOps best practices.

## Pipeline Overview

**Name**: `Terraform CI pipeline for infra deployment`
**Trigger**: Automatically runs when code is pushed to the `main` branch
**Runner**: Uses Ubuntu latest environment

## Workflow Structure

### Trigger Configuration
```yaml
on:
  push:
    branches:
      - 'main'
```
- Pipeline activates only on pushes to the main branch
- Ensures production deployments happen from stable code

### Job: build-infra

The pipeline contains a single job that handles the complete Terraform deployment lifecycle:

#### Step 1: Code Checkout
```yaml
- name: Checkout
  uses: actions/checkout@v2
```
- Downloads the repository code to the runner
- Makes your Terraform files available for processing

#### Step 2: Terraform Setup
```yaml
- name: Terraform Setup
  uses: hashicorp/setup-terraform@v2
```
- Installs Terraform CLI on the Ubuntu runner
- Uses HashiCorp's official action for reliable setup

#### Step 3: AWS Authentication
```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_KEY }}
    aws-region: ap-south-1
```
- Securely authenticates with AWS using GitHub Secrets
- Sets up credentials for Mumbai region (ap-south-1)
- More secure than environment variables (commented out approach)

#### Step 4: Terraform Initialization
```yaml
- name: Terraform initialization
  id: init
  run: terraform init
  working-directory: ./Terraform-VPC
```
- Initializes Terraform in the `./Terraform-VPC` directory
- Downloads required providers and modules
- Sets up the backend configuration

#### Step 5: Terraform Validation
```yaml
- name: Terraform validation
  id: validate
  run: terraform validate
  working-directory: ./Terraform-VPC
```
- Validates Terraform configuration syntax
- Checks for errors before planning
- Fails fast if configuration is invalid

#### Step 6: Terraform Planning
```yaml
- name: Terraform planning
  id: plan
  run: terraform plan
  working-directory: ./Terraform-VPC
```
- Creates an execution plan
- Shows what resources will be created, modified, or destroyed
- No actual infrastructure changes occur here

#### Step 7: Terraform Deployment
```yaml
- name: Terraform final deployment
  id: apply
  run: terraform apply --auto-approve
  working-directory: ./Terraform-VPC
```
- Applies the planned changes to AWS infrastructure
- `--auto-approve` skips manual confirmation
- Actually creates/modifies AWS resources

## Security Features

### GitHub Secrets Integration
- AWS credentials stored securely in GitHub Secrets
- Prevents exposure of sensitive keys in code
- Accessed via `${{ secrets.SECRET_NAME }}` syntax

### Commented Environment Variables
```yaml
# env:
# AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY }}
# AWS_SECRET_ACCESS_KEY_ID: ${{ secrets.AWS_SECRET_KEY }}
```
- Shows alternative (less secure) credential method
- Current approach using `aws-actions/configure-aws-credentials` is preferred

## Best Practices Implemented

1. **Automated Validation**: Validates syntax before deployment
2. **Planning Phase**: Shows changes before applying them  
3. **Secure Authentication**: Uses GitHub Secrets and AWS action
4. **Organized Structure**: Terraform code separated in dedicated directory
5. **Step Identification**: Each step has unique ID for debugging

## Potential Improvements

1. **Add terraform fmt check** for code formatting
2. **Implement plan artifact saving** to review changes
3. **Add manual approval** for production deployments
4. **Include destroy job** for cleanup scenarios
5. **Add notification steps** for deployment status
6. **Use terraform workspaces** for multiple environments

## Directory Structure Expected
```
repository-root/
├── .github/workflows/
│   └── deployment.yml (this file)
└── Terraform-VPC/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── modules
```
