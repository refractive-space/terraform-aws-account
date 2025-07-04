# Local values for account creation
locals {
  # Generate email if not provided, using email_prefix and domain
  email = var.email == "" ? "${var.email_prefix}${random_uuid.name.id}@${var.domain}" : var.email
  # Generate name if not provided using random UUID
  name = var.name == "" ? random_uuid.name.id : var.name
}

# Validation to ensure domain is provided when email is not provided
resource "null_resource" "email_validation" {
  count = var.email == "" && var.domain == "" ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Error: domain variable is required when email is not provided' && exit 1"
  }
}

# Generate random UUID for unique naming when name/email not provided
resource "random_uuid" "name" {}

# Create AWS Organizations account
resource "aws_organizations_account" "this" {
  email                      = local.email
  iam_user_access_to_billing = var.billing_access
  name                       = local.name
  parent_id                  = var.parent_id
  role_name                  = var.role_name
  
  # Apply tags to the account
  tags = var.tags

  # Account lifecycle management
  lifecycle {
    # Ignore changes to these attributes after creation to prevent accidental modifications
    ignore_changes = [
      email,
      iam_user_access_to_billing,
      name,
      role_name,
    ]
    
    # Prevent accidental deletion of the account
    prevent_destroy = true
  }
}
