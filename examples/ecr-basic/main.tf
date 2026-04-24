# -----------------------------------------------------------------------------
# File: examples/ecr-basic/main.tf
# Purpose:
#   Demonstrates end-to-end usage for example 'ecr-basic'.
# Why this file exists:
#   Provides a runnable reference for adoption, testing, and onboarding without changing module internals.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

provider "aws" {
  region = var.region
}

locals {
  # Local Purpose: Defines derived value "create_repository_policy" once for reuse and consistent logic across this file.
  create_repository_policy = length(var.repository_pull_principal_arns) > 0

  # Local Purpose: Defines derived value "repository_policy_json" once for reuse and consistent logic across this file.
  # Ternary Purpose: Selects the "repository_policy_json" value by evaluating a condition and choosing true/false branches explicitly.
  repository_policy_json = local.create_repository_policy ? data.aws_iam_policy_document.repository_pull[0].json : null
}

# Data Purpose: Reads data source aws_iam_policy_document.repository_pull to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_iam_policy_document" "repository_pull" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = local.create_repository_policy ? 1 : 0

  statement {
    sid    = "AllowScopedPull"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.repository_pull_principal_arns
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  }
}

module "ecr" {
  source = "../../modules/ecr"

  name                    = var.repository_name
  image_tag_mutability    = var.image_tag_mutability
  scan_on_push            = var.scan_on_push
  encryption_type         = var.encryption_type
  kms_key_arn             = var.kms_key_arn
  force_delete            = var.force_delete
  enable_lifecycle_policy = true

  lifecycle_max_image_count = var.lifecycle_max_image_count
  lifecycle_tag_status      = var.lifecycle_tag_status
  lifecycle_tag_prefix_list = var.lifecycle_tag_prefix_list

  repository_policy_json = local.repository_policy_json

  tags = var.tags
}
