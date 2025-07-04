# Complete Account Example

This example demonstrates advanced usage of the terraform-aws-account module, showing all available configuration options and best practices for creating multiple AWS accounts.

## What This Example Does

- Creates three AWS accounts with different configurations:
  - **Production Account**: Full configuration with billing access enabled
  - **Staging Account**: Similar to production but with billing access disabled
  - **Sandbox Account**: Uses auto-generated email with custom domain

## Features Demonstrated

### 1. Production Account
- Custom IAM role name (`ProductionAdminRole`)
- Billing access enabled (`ALLOW`)
- Comprehensive tagging strategy
- Explicit email configuration

### 2. Staging Account
- Different IAM role name (`StagingAdminRole`)
- Billing access disabled (`DENY`)
- Environment-specific tags
- Separate email address

### 3. Sandbox Account
- Auto-generated email using custom domain
- Minimal configuration for experimentation
- Different backup policy

## Configuration Options

### Email Management
```hcl
# Explicit email
email = "prod-account@example.com"

# Auto-generated with domain
domain = "sandbox.example.com"
# Results in: {random-uuid}@sandbox.example.com
```

### Billing Access
```hcl
billing_access = "ALLOW"  # or "DENY"
```

### IAM Role Configuration
```hcl
role_name = "ProductionAdminRole"
```

### Comprehensive Tagging
```hcl
tags = {
  Environment    = "Production"
  BusinessUnit   = "Engineering"
  CostCenter     = "123456"
  Owner          = "platform-team@example.com"
  Purpose        = "Production workloads"
  ManagedBy      = "Terraform"
  DataClass      = "Internal"
  Project        = "Core Platform"
  Team           = "Platform Engineering"
  BackupPolicy   = "Required"
}
```

## Prerequisites

- AWS Organizations enabled
- IAM permissions for account creation
- Unique email addresses for each account
- The parent OU ID where accounts should be created
- Valid domain for auto-generated emails (if using)

## Usage

1. **Update the configuration**:
   ```hcl
   # Replace these values with your own
   email     = "your-unique-email@example.com"
   parent_id = "ou-your-ou-id"
   domain    = "your-domain.com"
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

## Best Practices Demonstrated

### 1. Consistent Tagging Strategy
All accounts use a consistent tagging strategy including:
- Environment classification
- Business unit and cost center
- Owner and team information
- Purpose and data classification
- Management and backup policies

### 2. Role Naming Convention
Each account uses environment-specific role names:
- `ProductionAdminRole`
- `StagingAdminRole`
- Default `bootstrapper` for sandbox

### 3. Billing Access Control
- Production: Billing access enabled for financial oversight
- Staging: Billing access disabled to prevent accidental costs
- Sandbox: Default (disabled) for cost control

### 4. Email Management
- Production/Staging: Explicit emails for accountability
- Sandbox: Auto-generated for temporary/experimental use

## Expected Outputs

The example provides comprehensive outputs including:

- Individual account details (ID, ARN, email, etc.)
- Summary of all created accounts
- List of account IDs for easy reference

## Security Considerations

1. **IAM Roles**: Each account has a specific role for cross-account access
2. **Billing Access**: Controlled based on environment needs
3. **Email Addresses**: Use organization-controlled email addresses
4. **Tagging**: Consistent tags for security and compliance

## Cost Management

1. **Cost Centers**: All accounts tagged with cost center for billing
2. **Owners**: Clear ownership for accountability
3. **Billing Access**: Controlled based on environment requirements
4. **Backup Policies**: Different backup requirements by environment

## Monitoring and Compliance

1. **Data Classification**: All accounts tagged with data classification
2. **Business Unit**: Clear business unit assignment
3. **Project/Team**: Detailed team and project information
4. **Purpose**: Clear purpose statement for each account

## Next Steps

After creating the accounts:

1. **Configure Cross-Account Access**: Set up roles and policies
2. **Implement Monitoring**: Set up CloudTrail, Config, and monitoring
3. **Apply Governance**: Attach SCPs and tag policies
4. **Set Up Billing**: Configure billing alerts and cost monitoring
5. **Document Access**: Create runbooks for account access procedures

## Clean Up

⚠️ **Important**: This module includes `prevent_destroy = true` to prevent accidental account deletion. AWS accounts cannot be easily deleted once created, so plan accordingly.