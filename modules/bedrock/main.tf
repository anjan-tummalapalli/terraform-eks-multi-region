# -----------------------------------------------------------------------------
# File: modules/bedrock/main.tf
# Purpose:
#   Implements resource orchestration for module 'bedrock'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Data Purpose: Reads data source aws_caller_identity.current to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_caller_identity" "current" {}

# Data Purpose: Reads data source aws_partition.current to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_partition" "current" {}

# Data Purpose: Reads data source aws_region.current to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_region" "current" {}

locals {
  # Local Purpose: Defines derived value "enable_s3_logging" once for reuse and consistent logic across this file.
  enable_s3_logging = var.s3_bucket_name != null && trim(var.s3_bucket_name) != ""

  # Local Purpose: Defines derived value "effective_log_group_name" once for reuse and consistent logic across this file.
  effective_log_group_name = coalesce(var.cloudwatch_log_group_name, "/aws/bedrock/model-invocations/${var.name_prefix}")

  # Local Purpose: Defines derived value "effective_role_arn" once for reuse and consistent logic across this file.
  effective_role_arn = var.enable_cloudwatch_logging ? (
    # Ternary Purpose: Evaluates a condition inline to choose between two expression branches.
    var.create_logging_role ? aws_iam_role.bedrock_logging[0].arn : var.logging_role_arn
  ) : null

  # Local Purpose: Defines derived value "cloudwatch_log_group_arn" once for reuse and consistent logic across this file.
  cloudwatch_log_group_arn = "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.effective_log_group_name}"
}

# Data Purpose: Reads data source aws_iam_policy_document.assume_role to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowBedrockAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Data Purpose: Reads data source aws_iam_policy_document.logging to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "logging" {
  statement {
    sid    = "AllowCloudWatchLogGroupCreation"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatchLogWrites"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      local.cloudwatch_log_group_arn,
      "${local.cloudwatch_log_group_arn}:*"
    ]
  }

  # Dynamic Purpose: Adds an Identity and Access Management (IAM) statement for Simple Storage Service (S3) delivery only when Bedrock log delivery to Simple Storage Service (S3) is enabled.
  dynamic "statement" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition and choosing true/false branches explicitly.
    for_each = local.enable_s3_logging ? [1] : []
    content {
      sid    = "AllowS3Delivery"
      effect = "Allow"

      actions = [
        "s3:GetBucketLocation",
        "s3:PutObject"
      ]

      resources = [
        "arn:${data.aws_partition.current.partition}:s3:::${var.s3_bucket_name}",
        "arn:${data.aws_partition.current.partition}:s3:::${var.s3_bucket_name}/${coalesce(var.s3_key_prefix, "")}*"
      ]
    }
  }
}

# Resource Purpose: Creates a CloudWatch Logs group with retention and optional encryption settings (aws_cloudwatch_log_group.this).
resource "aws_cloudwatch_log_group" "this" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = var.enable_cloudwatch_logging && var.create_cloudwatch_log_group ? 1 : 0

  name              = local.effective_log_group_name
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_id

  tags = merge(var.tags, {
    Name = local.effective_log_group_name
  })
}

# Resource Purpose: Creates an Identity and Access Management (IAM) role assumed by Amazon Web Services (AWS) services or workloads (aws_iam_role.bedrock_logging).
resource "aws_iam_role" "bedrock_logging" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = var.enable_cloudwatch_logging && var.create_logging_role ? 1 : 0

  name               = coalesce(var.logging_role_name, "${var.name_prefix}-bedrock-logging-role")
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(var.tags, {
    Name = coalesce(var.logging_role_name, "${var.name_prefix}-bedrock-logging-role")
  })
}

# Resource Purpose: Attaches an inline Identity and Access Management (IAM) policy document directly to a role (aws_iam_role_policy.bedrock_logging).
resource "aws_iam_role_policy" "bedrock_logging" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = var.enable_cloudwatch_logging && var.create_logging_role ? 1 : 0

  name   = "${var.name_prefix}-bedrock-logging-inline"
  role   = aws_iam_role.bedrock_logging[0].id
  policy = data.aws_iam_policy_document.logging.json
}

# Resource Purpose: Configures Bedrock model invocation logging destinations and payload delivery options (aws_bedrock_model_invocation_logging_configuration.this).
resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  logging_config {
    text_data_delivery_enabled      = var.text_data_delivery_enabled
    image_data_delivery_enabled     = var.image_data_delivery_enabled
    embedding_data_delivery_enabled = var.embedding_data_delivery_enabled
    video_data_delivery_enabled     = var.video_data_delivery_enabled

    # Dynamic Purpose: Adds CloudWatch logging destination settings only when CloudWatch delivery is enabled.
    dynamic "cloudwatch_config" {
      # Ternary Purpose: Selects the "for_each" value by evaluating a condition and choosing true/false branches explicitly.
      for_each = var.enable_cloudwatch_logging ? [1] : []
      content {
        log_group_name = local.effective_log_group_name
        role_arn       = local.effective_role_arn

        # Dynamic Purpose: Adds Simple Storage Service (S3) delivery configuration for large payload logs only when Simple Storage Service (S3) logging is enabled.
        dynamic "large_data_delivery_s3_config" {
          # Ternary Purpose: Selects the "for_each" value by evaluating a condition and choosing true/false branches explicitly.
          for_each = local.enable_s3_logging ? [1] : []
          content {
            bucket_name = var.s3_bucket_name
            key_prefix  = var.s3_key_prefix
          }
        }
      }
    }

    # Dynamic Purpose: Adds primary Simple Storage Service (S3) logging destination settings only when Simple Storage Service (S3) delivery is enabled.
    dynamic "s3_config" {
      # Ternary Purpose: Selects the "for_each" value by evaluating a condition and choosing true/false branches explicitly.
      for_each = local.enable_s3_logging ? [1] : []
      content {
        bucket_name = var.s3_bucket_name
        key_prefix  = var.s3_key_prefix
      }
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy.bedrock_logging
  ]

  lifecycle {
    precondition {
      condition     = var.enable_cloudwatch_logging || local.enable_s3_logging
      error_message = "Enable at least one Bedrock logging destination: CloudWatch or S3."
    }

    precondition {
      condition     = !var.enable_cloudwatch_logging || var.create_logging_role || var.logging_role_arn != null
      error_message = "Set logging_role_arn when enable_cloudwatch_logging is true and create_logging_role is false."
    }

    precondition {
      condition = (
        var.text_data_delivery_enabled ||
        var.image_data_delivery_enabled ||
        var.embedding_data_delivery_enabled ||
        var.video_data_delivery_enabled
      )
      error_message = "At least one Bedrock payload type must be enabled for delivery."
    }
  }
}
