terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Complete account creation with all options including budget
module "production_account" {
  source = "../../"

  name           = "Production Account"
  email          = "prod-account@example.com"
  parent_id      = "ou-1234567890abcdef0"  # Replace with your OU ID
  role_name      = "ProductionAdminRole"
  billing_access = "ALLOW"

  # Enable comprehensive budget monitoring for production
  enable_budget       = true
  budget_limit_amount = "10000"
  budget_time_unit    = "MONTHLY"
  budget_type         = "COST"

  # Multi-tier notification system for production
  budget_notifications = [
    {
      comparison_operator        = "GREATER_THAN"
      threshold                 = 50
      threshold_type            = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = ["finance@example.com", "platform-team@example.com"]
      subscriber_sns_topic_arns  = []
    },
    {
      comparison_operator        = "GREATER_THAN"
      threshold                 = 75
      threshold_type            = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = ["finance@example.com", "platform-team@example.com", "exec-team@example.com"]
      subscriber_sns_topic_arns  = []
    },
    {
      comparison_operator        = "GREATER_THAN"
      threshold                 = 90
      threshold_type            = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_email_addresses = ["finance@example.com", "platform-team@example.com", "exec-team@example.com"]
      subscriber_sns_topic_arns  = []
    }
  ]

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
}

# Example of creating multiple accounts with different configurations
module "staging_account" {
  source = "../../"

  name           = "Staging Account"
  email          = "staging-account@example.com"
  parent_id      = "ou-1234567890abcdef0"  # Replace with your OU ID
  role_name      = "StagingAdminRole"
  billing_access = "DENY"

  tags = {
    Environment    = "Staging"
    BusinessUnit   = "Engineering"
    CostCenter     = "123456"
    Owner          = "platform-team@example.com"
    Purpose        = "Pre-production testing"
    ManagedBy      = "Terraform"
    DataClass      = "Internal"
    Project        = "Core Platform"
    Team           = "Platform Engineering"
    BackupPolicy   = "Optional"
  }
}

# Example with auto-generated email using custom prefix
module "sandbox_account" {
  source = "../../"

  name         = "Sandbox Account"
  parent_id    = "ou-1234567890abcdef0"  # Replace with your OU ID
  email_prefix = "sandbox-team"
  domain       = "accounts.example.com"  # Will generate sandbox-team@accounts.example.com

  tags = {
    Environment    = "Sandbox"
    BusinessUnit   = "Engineering"
    CostCenter     = "123456"
    Owner          = "platform-team@example.com"
    Purpose        = "Experimentation and testing"
    ManagedBy      = "Terraform"
    DataClass      = "Internal"
    Project        = "Core Platform"
    Team           = "Platform Engineering"
    BackupPolicy   = "None"
  }
}