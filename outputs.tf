# The ARN of the created AWS account
output "arn" {
  description = "The ARN of the AWS account"
  value       = aws_organizations_account.this.arn
}

# The ID of the created AWS account
output "id" {
  description = "The ID of the AWS account"
  value       = aws_organizations_account.this.id
}

# The name of the AWS account
output "name" {
  description = "The name of the AWS account"
  value       = local.name
}

# The email address associated with the AWS account
output "email" {
  description = "The email address associated with the AWS account"
  value       = local.email
}

# The IAM role name for cross-account access
output "role_name" {
  description = "The IAM role name for cross-account access"
  value       = var.role_name
}

# The status of the AWS account
output "status" {
  description = "The status of the AWS account"
  value       = aws_organizations_account.this.status
}

# The joined method of the AWS account
output "joined_method" {
  description = "The method by which the account joined the organization"
  value       = aws_organizations_account.this.joined_method
}

# The join timestamp of the AWS account
output "joined_timestamp" {
  description = "The timestamp when the account joined the organization"
  value       = aws_organizations_account.this.joined_timestamp
}

# Budget outputs (conditional)
output "budget_name" {
  description = "The name of the budget (if enabled)"
  value       = var.enable_budget ? aws_budgets_budget.account_budget[0].name : null
}

output "budget_arn" {
  description = "The ARN of the budget (if enabled)"
  value       = var.enable_budget ? aws_budgets_budget.account_budget[0].arn : null
}

# Service budget outputs (conditional)
output "service_budget_names" {
  description = "Map of service budget names (if enabled)"
  value       = var.enable_service_budgets ? { for k, v in aws_budgets_budget.service_budgets : k => v.name } : {}
}

output "service_budget_arns" {
  description = "Map of service budget ARNs (if enabled)"
  value       = var.enable_service_budgets ? { for k, v in aws_budgets_budget.service_budgets : k => v.arn } : {}
}
