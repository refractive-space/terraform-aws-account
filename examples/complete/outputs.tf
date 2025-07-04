# Production Account Outputs
output "production_account_id" {
  description = "The ID of the production AWS account"
  value       = module.production_account.id
}

output "production_account_arn" {
  description = "The ARN of the production AWS account"
  value       = module.production_account.arn
}

output "production_account_email" {
  description = "The email address of the production AWS account"
  value       = module.production_account.email
}

output "production_account_role_name" {
  description = "The IAM role name for the production account"
  value       = module.production_account.role_name
}

output "production_account_joined_timestamp" {
  description = "When the production account joined the organization"
  value       = module.production_account.joined_timestamp
}

# Staging Account Outputs
output "staging_account_id" {
  description = "The ID of the staging AWS account"
  value       = module.staging_account.id
}

output "staging_account_arn" {
  description = "The ARN of the staging AWS account"
  value       = module.staging_account.arn
}

output "staging_account_email" {
  description = "The email address of the staging AWS account"
  value       = module.staging_account.email
}

# Sandbox Account Outputs
output "sandbox_account_id" {
  description = "The ID of the sandbox AWS account"
  value       = module.sandbox_account.id
}

output "sandbox_account_arn" {
  description = "The ARN of the sandbox AWS account"
  value       = module.sandbox_account.arn
}

output "sandbox_account_email" {
  description = "The auto-generated email address of the sandbox AWS account"
  value       = module.sandbox_account.email
}

output "sandbox_account_name" {
  description = "The name of the sandbox AWS account"
  value       = module.sandbox_account.name
}

# Summary outputs
output "all_account_ids" {
  description = "List of all created account IDs"
  value = [
    module.production_account.id,
    module.staging_account.id,
    module.sandbox_account.id
  ]
}

output "account_summary" {
  description = "Summary of all created accounts"
  value = {
    production = {
      id    = module.production_account.id
      email = module.production_account.email
      name  = module.production_account.name
    }
    staging = {
      id    = module.staging_account.id
      email = module.staging_account.email
      name  = module.staging_account.name
    }
    sandbox = {
      id    = module.sandbox_account.id
      email = module.sandbox_account.email
      name  = module.sandbox_account.name
    }
  }
}