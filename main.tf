# Local values for account creation
locals {
  # Generate email if not provided, using email_prefix and domain
  email = var.email == "" ? "${var.email_prefix}${random_uuid.name.id}@${var.domain}" : var.email
  # Generate name if not provided using random UUID
  name = var.name == "" ? random_uuid.name.id : var.name

  # Service name mapping to AWS service identifiers
  service_mapping = {
    # AI/ML Services
    bedrock       = "Amazon Bedrock"
    rekognition   = "Amazon Rekognition"
    sagemaker     = "Amazon SageMaker"
    textract      = "Amazon Textract"
    comprehend    = "Amazon Comprehend"
    translate     = "Amazon Translate"
    polly         = "Amazon Polly"
    lex           = "Amazon Lex"

    # Compute Services
    ec2           = "Amazon Elastic Compute Cloud - Compute"
    ecs           = "Amazon EC2 Container Service"
    eks           = "Amazon Elastic Kubernetes Service"
    lambda        = "AWS Lambda"
    batch         = "AWS Batch"
    fargate       = "AWS Fargate"
    lightsail     = "Amazon Lightsail"

    # Storage Services
    s3            = "Amazon Simple Storage Service"
    ebs           = "Amazon Elastic Block Store"
    efs           = "Amazon Elastic File System"
    fsx           = "Amazon FSx"
    glacier       = "Amazon Glacier"
    backup        = "AWS Backup"

    # Database Services
    rds           = "Amazon Relational Database Service"
    dynamodb      = "Amazon DynamoDB"
    redshift      = "Amazon Redshift"
    elasticache   = "Amazon ElastiCache"
    documentdb    = "Amazon DocumentDB (with MongoDB compatibility)"
    neptune       = "Amazon Neptune"
    timestream    = "Amazon Timestream"

    # Networking Services
    vpc           = "Amazon Virtual Private Cloud"
    cloudfront    = "Amazon CloudFront"
    route53       = "Amazon Route 53"
    elb           = "Elastic Load Balancing"
    apigw         = "Amazon API Gateway"
    directconnect = "AWS Direct Connect"

    # Security Services
    iam           = "AWS Identity and Access Management"
    kms           = "AWS Key Management Service"
    secrets       = "AWS Secrets Manager"
    waf           = "AWS WAF"
    shield        = "AWS Shield"
    guardduty     = "Amazon GuardDuty"
    inspector     = "Amazon Inspector"

    # Monitoring & Management
    cloudwatch    = "Amazon CloudWatch"
    cloudtrail    = "AWS CloudTrail"
    config        = "AWS Config"
    xray          = "AWS X-Ray"
    systems       = "AWS Systems Manager"

    # Developer Tools
    codebuild     = "AWS CodeBuild"
    codedeploy    = "AWS CodeDeploy"
    codepipeline  = "AWS CodePipeline"
    codecommit    = "AWS CodeCommit"

    # Analytics
    athena        = "Amazon Athena"
    emr           = "Amazon EMR"
    kinesis       = "Amazon Kinesis"
    glue          = "AWS Glue"
    quicksight    = "Amazon QuickSight"

    # Application Integration
    sns           = "Amazon Simple Notification Service"
    sqs           = "Amazon Simple Queue Service"
    eventbridge   = "Amazon EventBridge"
    stepfunctions = "AWS Step Functions"

    # Other Services
    ses           = "Amazon Simple Email Service"
    workspaces    = "Amazon WorkSpaces"
    connect       = "Amazon Connect"
    chime         = "Amazon Chime"
    pinpoint      = "Amazon Pinpoint"
  }
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

# Create budget for conditional billing control (if enabled)
resource "aws_budgets_budget" "account_budget" {
  count = var.enable_budget ? 1 : 0

  name = "${local.name}-budget"

  budget_type       = var.budget_type
  limit_amount      = var.budget_limit_amount
  limit_unit        = var.budget_limit_unit
  time_period_start = formatdate("YYYY-MM-01_00:00", timestamp())
  time_unit         = var.budget_time_unit

  dynamic "cost_filter" {
    for_each = length(var.budget_cost_filters) > 0 ? var.budget_cost_filters : {
      LinkedAccount = [aws_organizations_account.this.id]
    }
    content {
      name   = cost_filter.key
      values = cost_filter.value
    }
  }

  dynamic "notification" {
    for_each = local.merged_budget_notifications
    content {
      comparison_operator        = notification.value.comparison_operator
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = notification.value.subscriber_email_addresses
      subscriber_sns_topic_arns  = notification.value.subscriber_sns_topic_arns
    }
  }

  depends_on = [aws_organizations_account.this]
}

# Create service-level budgets (if enabled)
resource "aws_budgets_budget" "service_budgets" {
  for_each = var.enable_service_budgets ? var.service_budgets : {}

  name = "${local.name}-${each.key}-budget"

  budget_type       = each.value.budget_type
  limit_amount      = each.value.limit_amount
  limit_unit        = each.value.limit_unit
  time_period_start = formatdate("YYYY-MM-01_00:00", timestamp())
  time_unit         = each.value.time_unit

  # Filter by service and linked account
  cost_filter {
    name   = "LinkedAccount"
    values = [aws_organizations_account.this.id]
  }

  cost_filter {
    name   = "Service"
    values = [local.service_mapping[each.key]]
  }

  # Add notifications if specified, otherwise use default
  dynamic "notification" {
    for_each = length(each.value.notifications) > 0 ? each.value.notifications : [{
      comparison_operator        = "GREATER_THAN"
      threshold                  = 80
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = []
      subscriber_sns_topic_arns  = []
    }]
    content {
      comparison_operator        = notification.value.comparison_operator
      threshold                  = notification.value.threshold
      threshold_type             = notification.value.threshold_type
      notification_type          = notification.value.notification_type
      subscriber_email_addresses = notification.value.subscriber_email_addresses
      subscriber_sns_topic_arns  = notification.value.subscriber_sns_topic_arns
    }
  }

  depends_on = [aws_organizations_account.this]
}
