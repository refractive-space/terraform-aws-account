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