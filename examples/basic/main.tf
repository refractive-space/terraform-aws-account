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

# Basic account creation
module "basic_account" {
  source = "../../"

  name      = "Development Account"
  email     = "dev-account@example.com"
  parent_id = "r-1234567890abcdef0"  # Replace with your root ID or OU ID

  tags = {
    Environment = "Development"
    Purpose     = "Application development and testing"
    ManagedBy   = "Terraform"
  }
}

# Basic account with budget for billing control
module "basic_account_with_budget" {
  source = "../../"

  name      = "Development Account with Budget"
  email     = "dev-budget-account@example.com"
  parent_id = "r-1234567890abcdef0"  # Replace with your root ID or OU ID

  # Enable budget for billing control
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
    },
    {
      comparison_operator        = "GREATER_THAN"
      threshold                 = 100
      threshold_type            = "PERCENTAGE"
      notification_type          = "FORECASTED"
      subscriber_email_addresses = ["billing-alerts@example.com"]
      subscriber_sns_topic_arns  = []
    }
  ]

  tags = {
    Environment = "Development"
    Purpose     = "Application development and testing with cost controls"
    ManagedBy   = "Terraform"
  }
}