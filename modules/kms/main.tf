# -----------------------------------------------------------------------------
# File: modules/kms/main.tf
# Purpose:
#   Implements resource orchestration for module 'kms'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  effective_alias_name = coalesce(var.alias_name, var.name)

  key_usage_actions = [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:ReEncrypt*",
    "kms:GenerateDataKey*",
    "kms:DescribeKey"
  ]
}

data "aws_iam_policy_document" "key_policy" {
  statement {
    sid    = "EnableRootPermissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  dynamic "statement" {
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

  dynamic "statement" {
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

  dynamic "statement" {
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

resource "aws_kms_alias" "primary" {
  count = var.create_alias ? 1 : 0

  name          = "alias/${local.effective_alias_name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_alias" "additional" {
  for_each = toset(var.additional_aliases)

  name          = "alias/${each.value}"
  target_key_id = aws_kms_key.this.key_id
}
