# The name of the AWS account to create
variable "name" {
  description = "The name of the AWS account to create. If empty, will be auto-generated using random UUID"
  type        = string
  default     = ""

  validation {
    condition     = var.name == "" || (length(var.name) > 0 && length(var.name) <= 50)
    error_message = "Account name must be between 1 and 50 characters or empty string."
  }
}

# The email address for the AWS account
variable "email" {
  description = "The email address associated with the AWS account. If empty, will be auto-generated using email_prefix and domain"
  type        = string
  default     = ""
  
  validation {
    condition     = var.email == "" || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "Email must be a valid email address format or empty string."
  }
}

# The parent organizational unit or root ID where this account will be created
variable "parent_id" {
  description = "The parent organizational unit ID or root ID where this account will be created"
  type        = string
  
  validation {
    condition     = can(regex("^(r-[0-9a-z]{4,32}|ou-[0-9a-z]{4,32}-[0-9a-z]{8,32})$", var.parent_id))
    error_message = "Parent ID must be a valid AWS Organizations root ID (r-) or organizational unit ID (ou-)."
  }
}

# Optional email prefix for auto-generated emails
variable "email_prefix" {
  description = "Optional prefix for auto-generated email addresses. If empty, will use random UUID"
  type        = string
  default     = ""

  validation {
    condition     = var.email_prefix == "" || can(regex("^[a-zA-Z0-9._+-]+$", var.email_prefix))
    error_message = "Email prefix must contain only letters, numbers, dots, underscores, hyphens, and plus symbols."
  }
}

# Optional domain for the account email
variable "domain" {
  description = "Optional domain for auto-generated email addresses. Required when email is not provided"
  type        = string
  default     = ""

  validation {
    condition     = var.domain == "" || can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.domain))
    error_message = "Domain must be a valid domain name format."
  }
}

# IAM role name for cross-account access
variable "role_name" {
  description = "The name of the IAM role to create for cross-account access"
  type        = string
  default     = "bootstrapper"
  
  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "Role name must be between 1 and 64 characters."
  }
}

# Billing access permissions for the account
variable "billing_access" {
  description = "Whether to allow or deny billing access for the account"
  type        = string
  default     = "DENY"
  
  validation {
    condition     = contains(["ALLOW", "DENY"], var.billing_access)
    error_message = "Billing access must be either ALLOW or DENY."
  }
}

# Tags to apply to all resources
variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

# Budget configuration for conditional billing control
variable "enable_budget" {
  description = "Whether to enable billing budget for the account"
  type        = bool
  default     = false
}

variable "budget_limit_amount" {
  description = "The amount of cost or usage being measured for a budget"
  type        = string
  default     = "100"
}

variable "budget_limit_unit" {
  description = "The unit of measurement used for the budget forecast, actual spend, or budget threshold (USD for cost budgets)"
  type        = string
  default     = "USD"

  validation {
    condition     = contains(["USD"], var.budget_limit_unit)
    error_message = "Budget limit unit must be USD for cost budgets."
  }
}

variable "budget_time_unit" {
  description = "The length of time until a budget resets the actual and forecasted spend"
  type        = string
  default     = "MONTHLY"

  validation {
    condition     = contains(["DAILY", "MONTHLY", "QUARTERLY", "ANNUALLY"], var.budget_time_unit)
    error_message = "Budget time unit must be one of: DAILY, MONTHLY, QUARTERLY, ANNUALLY."
  }
}

variable "budget_type" {
  description = "Whether this budget tracks monetary cost or usage"
  type        = string
  default     = "COST"

  validation {
    condition     = contains(["USAGE", "COST", "RI_UTILIZATION", "RI_COVERAGE", "SAVINGS_PLANS_UTILIZATION", "SAVINGS_PLANS_COVERAGE"], var.budget_type)
    error_message = "Budget type must be one of: USAGE, COST, RI_UTILIZATION, RI_COVERAGE, SAVINGS_PLANS_UTILIZATION, SAVINGS_PLANS_COVERAGE."
  }
}

variable "budget_notifications" {
  description = "List of notification configurations for the budget"
  type = list(object({
    comparison_operator        = string
    threshold                  = number
    threshold_type             = string
    notification_type          = string
    subscriber_email_addresses = list(string)
    subscriber_sns_topic_arns  = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for notification in var.budget_notifications :
      contains(["GREATER_THAN", "LESS_THAN", "EQUAL_TO"], notification.comparison_operator)
    ])
    error_message = "Budget notification comparison_operator must be one of: GREATER_THAN, LESS_THAN, EQUAL_TO."
  }

  validation {
    condition = alltrue([
      for notification in var.budget_notifications :
      contains(["PERCENTAGE", "ABSOLUTE_VALUE"], notification.threshold_type)
    ])
    error_message = "Budget notification threshold_type must be one of: PERCENTAGE, ABSOLUTE_VALUE."
  }

  validation {
    condition = alltrue([
      for notification in var.budget_notifications :
      contains(["ACTUAL", "FORECASTED"], notification.notification_type)
    ])
    error_message = "Budget notification notification_type must be one of: ACTUAL, FORECASTED."
  }
}

locals {
  default_budget_notification = {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = []
    subscriber_sns_topic_arns  = []
  }

  merged_budget_notifications = [
    for notification in var.budget_notifications : merge(local.default_budget_notification, notification)
  ]
}

variable "budget_cost_filters" {
  description = "Map of Cost Filter names and values for the budget"
  type        = map(list(string))
  default     = {}
}
