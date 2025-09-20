# AWS Organizations Account Terraform Module

[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/your-org/account/aws)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Terraform Version](https://img.shields.io/badge/terraform-%3E%3D1.8.0-blue.svg)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/aws-%3E%3D5.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)

A lightweight Terraform module for creating and managing AWS Organizations member accounts with comprehensive configuration options and safety features.

## Features

- ✅ **Simple Account Creation** - Create member accounts with minimal configuration
- ✅ **Email Management** - Flexible email handling with domain support
- ✅ **Automatic Naming** - Generate unique names and emails when not provided
- ✅ **Billing Control** - Configure billing access permissions
- ✅ **Conditional Billing Control** - Optional AWS Budgets integration for cost monitoring and alerts
- ✅ **Cross-Account Access** - Set up IAM roles for account management
- ✅ **Input Validation** - Built-in validation for all inputs
- ✅ **Lifecycle Management** - Prevent accidental account deletion
- ✅ **Comprehensive Outputs** - Access all account details and metadata

## Usage

### Basic Example

```hcl
module "development_account" {
  source = "your-org/account/aws"
  
  name      = "Development Account"
  email     = "dev-account@example.com"
  parent_id = "ou-1234567890abcdef0"  # Your OU ID
  
  tags = {
    Environment = "Development"
    Team        = "Platform"
  }
}
```

### With Custom Role and Billing Access

```hcl
module "production_account" {
  source = "your-org/account/aws"
  
  name           = "Production Account"
  email          = "prod-account@example.com"
  parent_id      = "ou-1234567890abcdef0"
  role_name      = "AdminRole"
  billing_access = "ALLOW"
  
  tags = {
    Environment = "Production"
    Team        = "Engineering"
    CostCenter  = "123456"
  }
}
```

### With Auto-Generated Email

```hcl
module "sandbox_account" {
  source = "your-org/account/aws"
  
  name         = "Sandbox Account"
  parent_id    = "ou-1234567890abcdef0"
  email_prefix = "sandbox-dev"
  domain       = "accounts.example.com"
  
  tags = {
    Environment = "Sandbox"
    Purpose     = "Testing"
  }
}
```

### With Budget Control

```hcl
module "monitored_account" {
  source = "your-org/account/aws"

  name      = "Development Account"
  email     = "dev-account@example.com"
  parent_id = "ou-1234567890abcdef0"

  # Enable budget for cost control
  enable_budget       = true
  budget_limit_amount = "500"
  budget_time_unit    = "MONTHLY"

  # Configure budget notifications
  budget_notifications = [
    {
      comparison_operator        = "GREATER_THAN"
      threshold                 = 80
      threshold_type            = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = ["billing-alerts@example.com"]
      subscriber_sns_topic_arns  = []
    }
  ]

  tags = {
    Environment = "Development"
    Team        = "Platform"
  }
}
```

### Complete Example

```hcl
module "compliance_account" {
  source = "your-org/account/aws"

  name           = "Compliance Account"
  email          = "compliance@example.com"
  parent_id      = "ou-1234567890abcdef0"
  role_name      = "ComplianceRole"
  billing_access = "DENY"

  # Enable comprehensive budget monitoring
  enable_budget       = true
  budget_limit_amount = "1000"
  budget_time_unit    = "MONTHLY"
  budget_type         = "COST"

  budget_notifications = [
    {
      comparison_operator        = "GREATER_THAN"
      threshold                 = 75
      threshold_type            = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = ["finance@example.com", "compliance-team@example.com"]
      subscriber_sns_topic_arns  = []
    },
    {
      comparison_operator        = "GREATER_THAN"
      threshold                 = 100
      threshold_type            = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_email_addresses = ["finance@example.com", "compliance-team@example.com"]
      subscriber_sns_topic_arns  = []
    }
  ]

  tags = {
    Environment    = "Compliance"
    BusinessUnit   = "Legal"
    DataClass      = "Confidential"
    ManagedBy      = "Terraform"
    Owner          = "compliance-team@example.com"
  }
}
```

## Examples

See the [examples](./examples) directory for more comprehensive usage patterns:

- [Basic](./examples/basic) - Simple account creation
- [Complete](./examples/complete) - Full-featured example with all options

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.account_budget](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_organizations_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [null_resource.email_validation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_uuid.name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the AWS account to create. If empty, will be auto-generated using random UUID | `string` | `""` | no |
| <a name="input_email"></a> [email](#input\_email) | The email address associated with the AWS account. If empty, will be auto-generated using email_prefix and domain | `string` | `""` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | The parent organizational unit ID or root ID where this account will be created | `string` | n/a | yes |
| <a name="input_email_prefix"></a> [email\_prefix](#input\_email\_prefix) | Optional prefix for auto-generated email addresses. If empty, will use random UUID | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Optional domain for auto-generated email addresses. Required when email is not provided | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | The name of the IAM role to create for cross-account access | `string` | `"bootstrapper"` | no |
| <a name="input_billing_access"></a> [billing\_access](#input\_billing\_access) | Whether to allow or deny billing access for the account | `string` | `"DENY"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to all resources | `map(string)` | `{}` | no |
| <a name="input_enable_budget"></a> [enable\_budget](#input\_enable\_budget) | Whether to enable billing budget for the account | `bool` | `false` | no |
| <a name="input_budget_limit_amount"></a> [budget\_limit\_amount](#input\_budget\_limit\_amount) | The amount of cost or usage being measured for a budget | `string` | `"100"` | no |
| <a name="input_budget_limit_unit"></a> [budget\_limit\_unit](#input\_budget\_limit\_unit) | The unit of measurement used for the budget forecast, actual spend, or budget threshold (USD for cost budgets) | `string` | `"USD"` | no |
| <a name="input_budget_time_unit"></a> [budget\_time\_unit](#input\_budget\_time\_unit) | The length of time until a budget resets the actual and forecasted spend | `string` | `"MONTHLY"` | no |
| <a name="input_budget_type"></a> [budget\_type](#input\_budget\_type) | Whether this budget tracks monetary cost or usage | `string` | `"COST"` | no |
| <a name="input_budget_notifications"></a> [budget\_notifications](#input\_budget\_notifications) | List of notification configurations for the budget | `list(object({...}))` | `[]` | no |
| <a name="input_budget_cost_filters"></a> [budget\_cost\_filters](#input\_budget\_cost\_filters) | Map of Cost Filter names and values for the budget | `map(list(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the AWS account |
| <a name="output_id"></a> [id](#output\_id) | The ID of the AWS account |
| <a name="output_name"></a> [name](#output\_name) | The name of the AWS account |
| <a name="output_email"></a> [email](#output\_email) | The email address associated with the AWS account |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | The IAM role name for cross-account access |
| <a name="output_status"></a> [status](#output\_status) | The status of the AWS account |
| <a name="output_joined_method"></a> [joined\_method](#output\_joined\_method) | The method by which the account joined the organization |
| <a name="output_joined_timestamp"></a> [joined\_timestamp](#output\_joined\_timestamp) | The timestamp when the account joined the organization |
| <a name="output_budget_name"></a> [budget\_name](#output\_budget\_name) | The name of the budget (if enabled) |
| <a name="output_budget_arn"></a> [budget\_arn](#output\_budget\_arn) | The ARN of the budget (if enabled) |

## Prerequisites

Before using this module, ensure you have:

1. **AWS Organizations enabled** in your management account
2. **Appropriate IAM permissions** for Organizations operations:
   - `organizations:CreateAccount`
   - `organizations:DescribeAccount`
   - `organizations:TagResource`
   - `organizations:ListTagsForResource`
3. **Valid email addresses** that are not already associated with AWS accounts
4. **SES verification** (if using custom domains for email generation)

## Input Validation

This module includes comprehensive input validation:

- **Account Name**: Must be 1-50 characters or empty string
- **Email**: Must be a valid email address format or empty string
- **Email Prefix**: Must contain only letters, numbers, dots, underscores, hyphens, and plus symbols
- **Domain**: Must be a valid domain name format
- **Parent ID**: Must be valid AWS Organizations root ID (`r-*`) or OU ID (`ou-*`)
- **Role Name**: Must be 1-64 characters
- **Billing Access**: Must be either "ALLOW" or "DENY"
- **Email/Domain Dependency**: Domain is required when email is not provided

## Account Lifecycle Management

This module implements several safety features:

### Prevent Destroy
The `prevent_destroy` lifecycle rule prevents accidental account deletion through Terraform.

### Ignore Changes
The following attributes are ignored after account creation to prevent drift:
- `email` - Email cannot be changed after account creation
- `iam_user_access_to_billing` - Billing access is typically set once
- `name` - Account name changes are rare and often handled outside Terraform
- `role_name` - Role names are usually consistent across the organization

## Email Management

The module supports flexible email handling:

### Explicit Email
```hcl
email = "specific@example.com"
```

### Auto-Generated Email with Custom Prefix
```hcl
email_prefix = "dev-team"
domain       = "accounts.example.com"
# Results in: dev-team@accounts.example.com
```

### Auto-Generated Email with Random UUID
```hcl
domain = "accounts.example.com"
# Results in: {random-uuid}@accounts.example.com
```

### Email Generation Logic
- If `email` is provided, it's used directly
- If `email` is empty, auto-generation uses:
  - `email_prefix` if provided, otherwise random UUID
  - Combined with `domain` (required when email is empty)
  - Final format: `{email_prefix|random-uuid}@{domain}`

## Common Use Cases

### 1. Multi-Environment Setup
Create separate accounts for development, staging, and production environments.

### 2. Team Isolation
Provide isolated AWS accounts for different teams or projects.

### 3. Compliance Requirements
Create accounts with specific configurations for regulatory compliance.

### 4. Cost Management
Separate accounts for better cost tracking and billing management with optional budget controls.

### 5. Security Boundaries
Use account-level isolation as a security boundary between workloads.

### 6. Billing Control and Monitoring
Set up automated cost monitoring with configurable budget alerts and notifications.

## Security Considerations

1. **Email Addresses**: Ensure email addresses are controlled by your organization
2. **IAM Roles**: Use consistent role names across accounts for easier management
3. **Billing Access**: Carefully consider who needs billing access in each account
4. **Tags**: Use tags consistently for cost allocation and access control
5. **Budget Notifications**: Ensure budget notification emails are sent to appropriate stakeholders
6. **Cost Filters**: Use budget cost filters to monitor specific services or resources

## Troubleshooting

### Common Issues

1. **Email Already in Use**: AWS account emails must be globally unique
2. **Permission Denied**: Ensure your IAM user/role has Organizations permissions
3. **Invalid Parent ID**: Verify the parent OU or root ID exists and is accessible
4. **Account Limits**: AWS has limits on account creation frequency

### Best Practices

1. **Use Organizational Units**: Create accounts within appropriate OUs
2. **Consistent Naming**: Use consistent naming conventions across accounts
3. **Proper Tagging**: Tag accounts for cost management and governance
4. **Email Management**: Use a systematic approach to email address management

## Contributing

Contributions are welcome! Please read the contributing guidelines and submit pull requests to the main branch.

## License

This module is licensed under the **Apache License 2.0**, which means you can:

- ✅ **Use it freely** for any purpose (commercial or non-commercial)
- ✅ **Modify and distribute** your changes
- ✅ **Include it in proprietary software** without restriction
- ✅ **Use it forever** without worrying about license changes

The Apache License 2.0 is one of the most permissive open-source licenses, ensuring this module will always remain free and available for everyone. See [LICENSE](LICENSE) for the full license text.

## Support

For issues and questions:
- Check the [examples](./examples) directory
- Review the [Terraform AWS Organizations documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account)
- Open an issue in this repository