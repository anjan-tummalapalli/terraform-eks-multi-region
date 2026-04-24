# -----------------------------------------------------------------------------
# File: modules/sagemaker/main.tf
# Purpose:
#   Implements resource orchestration for module 'sagemaker'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in
# variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Data Purpose: Reads data source aws_caller_identity.current to fetch existing
# Amazon Web Services (AWS) context required by dependent expressions.
data "aws_caller_identity" "current" {}

# Data Purpose: Reads data source aws_partition.current to fetch existing
# Amazon Web Services (AWS) context required by dependent expressions.
data "aws_partition" "current" {}

# Data Purpose: Reads data source aws_region.current to fetch existing Amazon
# Web Services (AWS) context required by dependent expressions.
data "aws_region" "current" {}

locals {
  # Local Purpose: Defines derived value "effective_role_arn" once for reuse
  # and consistent logic across this file.
  # Ternary Purpose: Selects the "effective_role_arn" value by evaluating a
  # condition and choosing true/false branches explicitly.
  effective_role_arn = (
    var.create_execution_role
    ? aws_iam_role.execution[0].arn
    : var.execution_role_arn
  )

  # Local Purpose: Defines derived value "lifecycle_config_name" once for reuse
  # and consistent logic across this file.
  # Ternary Purpose: Selects the "lifecycle_config_name" value by evaluating a
  # condition and choosing true/false branches explicitly.
  lifecycle_config_name = (
    var.create_lifecycle_configuration
    ? aws_sagemaker_notebook_instance_lifecycle_configuration.this[0].name
    : var.existing_lifecycle_config_name
  )

  # Local Purpose: Defines derived value "s3_resource_arns" once for reuse and
  # consistent logic across this file.
  s3_resource_arns = distinct(flatten([
    for bucket_arn in var.allowed_s3_bucket_arns : [
      bucket_arn,
      "${bucket_arn}/*"
    ]
  ]))
}

# Data Purpose: Reads data source aws_iam_policy_document.assume_role to fetch
# existing Amazon Web Services (AWS) context required by dependent expressions.
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

# Data Purpose: Reads data source aws_iam_policy_document.execution to fetch
# existing Amazon Web Services (AWS) context required by dependent expressions.
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
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/sagemaker/*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      ),
      format(
        "arn:%s:logs:%s:%s:log-group:/aws/sagemaker/*:*",
        data.aws_partition.current.partition,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }

  # Dynamic Purpose: Adds an Identity and Access Management (IAM) statement
  # granting notebook Simple Storage Service (S3) access only when bucket
  # Amazon Resource Names (ARNs) are provided.
  dynamic "statement" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition
    # and choosing true/false branches explicitly.
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

  # Dynamic Purpose: Adds an Identity and Access Management (IAM) statement
  # granting Key Management Service (KMS) usage only when a notebook Key
  # Management Service (KMS) key is configured.
  dynamic "statement" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition
    # and choosing true/false branches explicitly.
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

# Resource Purpose: Creates an Identity and Access Management (IAM) role
# assumed by Amazon Web Services (AWS) services or workloads
# (aws_iam_role.execution).
resource "aws_iam_role" "execution" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.create_execution_role ? 1 : 0

  name = (
    coalesce(var.execution_role_name, "${var.name}-execution-role")
  )
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  permissions_boundary = var.permissions_boundary_arn

  tags = merge(var.tags, {
    Name = coalesce(var.execution_role_name, "${var.name}-execution-role")
  })
}

# Resource Purpose: Attaches an inline Identity and Access Management (IAM)
# policy document directly to a role (aws_iam_role_policy.execution).
resource "aws_iam_role_policy" "execution" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.create_execution_role ? 1 : 0

  name   = "${var.name}-execution-inline"
  role   = aws_iam_role.execution[0].id
  policy = data.aws_iam_policy_document.execution.json
}

# Resource Purpose: Attaches a managed Identity and Access Management (IAM)
# policy to a role (aws_iam_role_policy_attachment.managed).
resource "aws_iam_role_policy_attachment" "managed" {
  # Ternary Purpose: Selects the "for_each" value by evaluating a condition and
  # choosing true/false branches explicitly.
  for_each = (
    var.create_execution_role ? toset(var.managed_policy_arns) : toset([])
  )

  role       = aws_iam_role.execution[0].name
  policy_arn = each.value
}

# Resource Purpose: Defines lifecycle scripts executed during notebook
# create/start events
# (aws_sagemaker_notebook_instance_lifecycle_configuration.this).
resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "this" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.create_lifecycle_configuration ? 1 : 0

  name = coalesce(var.lifecycle_configuration_name, "${var.name}-lifecycle")

  # Ternary Purpose: Selects the "on_create" value by evaluating a condition
  # and choosing true/false branches explicitly.
  on_create = (
    var.lifecycle_on_create == null
    ? null
    : base64encode(var.lifecycle_on_create)
  )
  # Ternary Purpose: Selects the "on_start" value by evaluating a condition and
  # choosing true/false branches explicitly.
  on_start = (
    var.lifecycle_on_start == null
    ? null
    : base64encode(var.lifecycle_on_start)
  )
}

# Resource Purpose: Creates a SageMaker notebook instance for interactive ML
# development (aws_sagemaker_notebook_instance.this).
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
    minimum_instance_metadata_service_version = (
      var.minimum_instance_metadata_service_version
    )
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}
