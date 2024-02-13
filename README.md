# Project Deployment Guide

This guide provides step-by-step instructions for deploying the project code to AWS.

## Prerequisites

Before you begin, ensure you have the following:

- Access to an AWS account
- AWS CLI installed and configured with appropriate permissions
- Terraform installed on your local machine

## Initial Setup

1. Clone the project repository to your local machine:

    ```bash
    git clone <repository_url>
    ```

2. Navigate to the project directory:

    ```bash
    cd <project_directory>
    ```

3. Update the AWS credentials in the `~/.aws/credentials` file with your own IAM user credentials.

4. Update account_id, aws_region, project_prefix, bucket_name and dynamo_db_table_name in:
    ```bash
    backend/variables.tf,
    environments/<env>/terraform.tfvars,
    environments/<env>/providers.tf
    ```
5. Set environment variables:
    ```bash
    export env=<env>
    export RDS_USERNAME=<your_username>
    export RDS_PASSWORD=<your_password>
    export AWS_REGION=<your_region>
    ```

## Deployment Steps

#### 1. Deploy Backend

Deploy the backend infrastructure using Terraform:
```bash
make deploy-backend
```
#### 2. Deploy Secrets for RDS
Deploy the secrets for RDS using Terraform:
```bash
make set-ssm-parameters
```
#### 3. Deploy Secrets for Infra
Deploy infrastructure using Terraform:
```bash
make apply-environment
```