output "account_id" {
  description = "The ID of the created AWS account"
  value       = module.basic_account.id
}

output "account_arn" {
  description = "The ARN of the created AWS account"
  value       = module.basic_account.arn
}

output "account_email" {
  description = "The email address of the created AWS account"
  value       = module.basic_account.email
}

output "account_name" {
  description = "The name of the created AWS account"
  value       = module.basic_account.name
}

output "account_status" {
  description = "The status of the created AWS account"
  value       = module.basic_account.status
}