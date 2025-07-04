# Local values for account creation
locals {
  # Generate email if not provided, using domain if specified
  email = var.email == "" ? "${random_uuid.name.id}@${var.domain}" : var.email
  # Generate name if not provided using random UUID
  name = var.name == "" ? random_uuid.name.id : var.name
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
