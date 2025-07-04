# Basic Account Example

This example demonstrates the simplest way to create an AWS account using the terraform-aws-account module.

## What This Example Does

- Creates a new AWS account with a specified name and email
- Places the account in a specified organizational unit or root
- Applies basic tags for identification

## Prerequisites

- AWS Organizations enabled
- IAM permissions for account creation
- A unique email address for the account
- The parent ID (root or OU) where the account should be created

## Configuration

The example includes:

- **Account Name**: "Development Account"
- **Email**: dev-account@example.com (you must change this)
- **Parent ID**: r-1234567890abcdef0 (you must change this)
- **Basic Tags**: Environment, Purpose, ManagedBy

## Usage

1. **Update the configuration**:
   ```hcl
   # Replace these values with your own
   email     = "your-unique-email@example.com"
   parent_id = "r-your-root-id"  # or "ou-your-ou-id"
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan the deployment**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

## Important Notes

- **Email Uniqueness**: The email address must be unique across all AWS accounts
- **Parent ID**: You can find your root ID or OU IDs using the AWS CLI:
  ```bash
  aws organizations list-roots --query 'Roots[0].Id' --output text
  ```
- **Account Creation Time**: AWS accounts can take several minutes to create
- **Account Limits**: AWS has limits on how frequently you can create accounts

## Expected Outputs

After successful creation, you'll see:

- `account_id`: The 12-digit AWS account ID
- `account_arn`: The full ARN of the account
- `account_email`: The email address used for the account
- `account_name`: The name of the account
- `account_status`: The current status (typically "ACTIVE")

## Next Steps

Once the account is created, you can:

1. **Access the account**: Use the role created by the module
2. **Configure the account**: Set up initial resources and configurations
3. **Apply policies**: Attach service control policies or tag policies
4. **Monitor costs**: Set up billing alerts and cost monitoring

## Clean Up

⚠️ **Important**: This module includes `prevent_destroy = true` to prevent accidental account deletion. AWS accounts cannot be easily deleted once created, so plan accordingly.