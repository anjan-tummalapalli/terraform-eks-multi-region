# -----------------------------------------------------------------------------
# File: modules/kms/main.tf
# Purpose:
#   Implements resource orchestration for module 'kms'.
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

locals {
  # Local Purpose: Defines derived value "effective_alias_name" once for reuse
  # and consistent logic across this file.
  effective_alias_name = coalesce(var.alias_name, var.name)

  # Local Purpose: Defines derived value "key_usage_actions" once for reuse and
  # consistent logic across this file.
  key_usage_actions = [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*",
    "kms:DescribeKey"
  ]
}

# Data Purpose: Reads data source aws_iam_policy_document.key_policy to fetch
# existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "key_policy" {
  statement {
    sid    = "EnableRootPermissions"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = (
        [
          format(
            "arn:%s:iam::%s:root",
            data.aws_partition.current.partition,
            data.aws_caller_identity.current.account_id
          )
        ]
      )
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Dynamic Purpose: Adds key-administration policy statements only when admin
  # principal Amazon Resource Names (ARNs) are supplied.
  dynamic "statement" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition
    # and choosing true/false branches explicitly.
    for_each = length(var.admin_principal_arns) > 0 ? [1] : []
    content {
      sid    = "AllowKeyAdministration"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.admin_principal_arns
      }

      actions = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion",
        "kms:TagResource",
        "kms:UntagResource"
      ]
      resources = ["*"]
    }
  }

  # Dynamic Purpose: Adds key-usage policy statements only when usage principal
  # Amazon Resource Names (ARNs) are supplied.
  dynamic "statement" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition
    # and choosing true/false branches explicitly.
    for_each = length(var.usage_principal_arns) > 0 ? [1] : []
    content {
      sid    = "AllowKeyUsageByPrincipals"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = var.usage_principal_arns
      }

      actions   = local.key_usage_actions
      resources = ["*"]
    }
  }

  # Dynamic Purpose: Adds service-principal key-usage statements only when
  # service principals are supplied.
  dynamic "statement" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition
    # and choosing true/false branches explicitly.
    for_each = length(var.service_principals) > 0 ? [1] : []
    content {
      sid    = "AllowKeyUsageByServices"
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = var.service_principals
      }

      actions   = local.key_usage_actions
      resources = ["*"]

      condition {
        test     = "StringEquals"
        variable = "kms:CallerAccount"
        values   = [data.aws_caller_identity.current.account_id]
      }
    }
  }
}

# Resource Purpose: Creates a customer-managed Key Management Service (KMS) key
# for encryption operations (aws_kms_key.this).
resource "aws_kms_key" "this" {
  description              = var.description
  key_usage                = var.key_usage
  customer_master_key_spec = var.key_spec
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  multi_region             = var.multi_region
  deletion_window_in_days  = var.deletion_window_in_days
  policy                   = data.aws_iam_policy_document.key_policy.json

  tags = merge(var.tags, {
    Name = var.name
  })
}

# Resource Purpose: Creates a friendly alias that points to a Key Management
# Service (KMS) key (aws_kms_alias.primary).
resource "aws_kms_alias" "primary" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.create_alias ? 1 : 0

  name          = "alias/${local.effective_alias_name}"
  target_key_id = aws_kms_key.this.key_id
}

# Resource Purpose: Creates a friendly alias that points to a Key Management
# Service (KMS) key (aws_kms_alias.additional).
resource "aws_kms_alias" "additional" {
  for_each = toset(var.additional_aliases)

  name          = "alias/${each.value}"
  target_key_id = aws_kms_key.this.key_id
}
