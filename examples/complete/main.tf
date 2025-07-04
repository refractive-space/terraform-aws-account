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

# Complete account creation with all options
module "production_account" {
  source = "../../"

  name           = "Production Account"
  email          = "prod-account@example.com"
  parent_id      = "ou-1234567890abcdef0"  # Replace with your OU ID
  role_name      = "ProductionAdminRole"
  billing_access = "ALLOW"

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

# Example with auto-generated email using domain
module "sandbox_account" {
  source = "../../"

  name      = "Sandbox Account"
  parent_id = "ou-1234567890abcdef0"  # Replace with your OU ID
  domain    = "sandbox.example.com"   # Will generate random-uuid@sandbox.example.com

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