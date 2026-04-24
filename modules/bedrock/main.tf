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

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  enable_s3_logging = var.s3_bucket_name != null && trim(var.s3_bucket_name) != ""

  effective_log_group_name = coalesce(var.cloudwatch_log_group_name, "/aws/bedrock/model-invocations/${var.name_prefix}")

  effective_role_arn = var.enable_cloudwatch_logging ? (
    var.create_logging_role ? aws_iam_role.bedrock_logging[0].arn : var.logging_role_arn
  ) : null

  cloudwatch_log_group_arn = "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.effective_log_group_name}"
}

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

  dynamic "statement" {
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

# Resource Purpose: Manages aws_cloudwatch_log_group resource "this" for this module/example deployment intent.
resource "aws_cloudwatch_log_group" "this" {
  count = var.enable_cloudwatch_logging && var.create_cloudwatch_log_group ? 1 : 0

  name              = local.effective_log_group_name
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_id

  tags = merge(var.tags, {
    Name = local.effective_log_group_name
  })
}

# Resource Purpose: Manages aws_iam_role resource "bedrock_logging" for this module/example deployment intent.
resource "aws_iam_role" "bedrock_logging" {
  count = var.enable_cloudwatch_logging && var.create_logging_role ? 1 : 0

  name               = coalesce(var.logging_role_name, "${var.name_prefix}-bedrock-logging-role")
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(var.tags, {
    Name = coalesce(var.logging_role_name, "${var.name_prefix}-bedrock-logging-role")
  })
}

# Resource Purpose: Manages aws_iam_role_policy resource "bedrock_logging" for this module/example deployment intent.
resource "aws_iam_role_policy" "bedrock_logging" {
  count = var.enable_cloudwatch_logging && var.create_logging_role ? 1 : 0

  name   = "${var.name_prefix}-bedrock-logging-inline"
  role   = aws_iam_role.bedrock_logging[0].id
  policy = data.aws_iam_policy_document.logging.json
}

# Resource Purpose: Manages aws_bedrock_model_invocation_logging_configuration resource "this" for this module/example deployment intent.
resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  logging_config {
    text_data_delivery_enabled      = var.text_data_delivery_enabled
    image_data_delivery_enabled     = var.image_data_delivery_enabled
    embedding_data_delivery_enabled = var.embedding_data_delivery_enabled
    video_data_delivery_enabled     = var.video_data_delivery_enabled

    dynamic "cloudwatch_config" {
      for_each = var.enable_cloudwatch_logging ? [1] : []
      content {
        log_group_name = local.effective_log_group_name
        role_arn       = local.effective_role_arn

        dynamic "large_data_delivery_s3_config" {
          for_each = local.enable_s3_logging ? [1] : []
          content {
            bucket_name = var.s3_bucket_name
            key_prefix  = var.s3_key_prefix
          }
        }
      }
    }

    dynamic "s3_config" {
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
