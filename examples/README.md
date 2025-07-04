# Examples

This directory contains examples showing how to use the terraform-aws-account module in different scenarios.

## Available Examples

### [Basic](./basic)
A simple example showing how to create an AWS account with minimal configuration.

### [Complete](./complete)
A comprehensive example showing all available configuration options and best practices.

## Prerequisites

Before running any examples, ensure you have:

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (>= 1.8.0)
3. **AWS Organizations enabled** in your management account
4. **Appropriate IAM permissions** for account creation

## Usage

1. Navigate to the example directory
2. Copy the example files to your own directory
3. Modify the variables as needed
4. Run `terraform init`
5. Run `terraform plan`
6. Run `terraform apply`

## Important Notes

- **Email Addresses**: Each AWS account requires a unique email address
- **Account Limits**: AWS has limits on how frequently you can create accounts
- **Billing**: Account creation may incur charges
- **Lifecycle Management**: The module includes `prevent_destroy` to avoid accidental deletion

## Common Variables

Most examples use these common variables:

- `name`: The name of the AWS account
- `email`: The email address for the account
- `parent_id`: The OU or root ID where the account should be created
- `tags`: Key-value pairs for resource tagging

## Getting Parent IDs

To find your root ID or OU IDs:

```bash
# Get root ID
aws organizations list-roots --query 'Roots[0].Id' --output text

# Get OU IDs
aws organizations list-organizational-units-for-parent --parent-id YOUR_ROOT_ID
```