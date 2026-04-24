# -----------------------------------------------------------------------------
# File: modules/sagemaker/main.tf
# Purpose:
#   Implements resource orchestration for module 'sagemaker'.
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
  effective_role_arn = var.create_execution_role ? aws_iam_role.execution[0].arn : var.execution_role_arn

  lifecycle_config_name = var.create_lifecycle_configuration ? aws_sagemaker_notebook_instance_lifecycle_configuration.this[0].name : var.existing_lifecycle_config_name

  s3_resource_arns = distinct(flatten([
    for bucket_arn in var.allowed_s3_bucket_arns : [
      bucket_arn,
      "${bucket_arn}/*"
    ]
  ]))
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid    = "AllowSageMakerServiceAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "execution" {
  statement {
    sid    = "AllowCloudWatchLogsCreateGroup"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatchLogsWrite"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/sagemaker/*",
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/sagemaker/*:*"
    ]
  }

  dynamic "statement" {
    for_each = length(local.s3_resource_arns) > 0 ? [1] : []
    content {
      sid    = "AllowS3DataAccess"
      effect = "Allow"

      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]

      resources = local.s3_resource_arns
    }
  }

  dynamic "statement" {
    for_each = var.kms_key_arn != null ? [1] : []
    content {
      sid    = "AllowKMSForNotebookVolume"
      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:Encrypt",
        "kms:GenerateDataKey*"
      ]

      resources = [var.kms_key_arn]
    }
  }
}

resource "aws_iam_role" "execution" {
  count = var.create_execution_role ? 1 : 0

  name                 = coalesce(var.execution_role_name, "${var.name}-execution-role")
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  permissions_boundary = var.permissions_boundary_arn

  tags = merge(var.tags, {
    Name = coalesce(var.execution_role_name, "${var.name}-execution-role")
  })
}

resource "aws_iam_role_policy" "execution" {
  count = var.create_execution_role ? 1 : 0

  name   = "${var.name}-execution-inline"
  role   = aws_iam_role.execution[0].id
  policy = data.aws_iam_policy_document.execution.json
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = var.create_execution_role ? toset(var.managed_policy_arns) : toset([])

  role       = aws_iam_role.execution[0].name
  policy_arn = each.value
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "this" {
  count = var.create_lifecycle_configuration ? 1 : 0

  name = coalesce(var.lifecycle_configuration_name, "${var.name}-lifecycle")

  on_create = var.lifecycle_on_create == null ? null : base64encode(var.lifecycle_on_create)
  on_start  = var.lifecycle_on_start == null ? null : base64encode(var.lifecycle_on_start)
}

resource "aws_sagemaker_notebook_instance" "this" {
  name          = var.name
  instance_type = var.instance_type
  role_arn      = local.effective_role_arn

  subnet_id              = var.subnet_id
  security_groups        = var.security_group_ids
  direct_internet_access = var.direct_internet_access
  root_access            = var.root_access
  volume_size            = var.volume_size
  kms_key_id             = var.kms_key_arn

  lifecycle_config_name = local.lifecycle_config_name

  instance_metadata_service_configuration {
    minimum_instance_metadata_service_version = var.minimum_instance_metadata_service_version
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}
