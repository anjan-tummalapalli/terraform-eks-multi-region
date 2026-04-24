# -----------------------------------------------------------------------------
# File: modules/ecr/main.tf
# Purpose:
#   Implements resource orchestration for module 'ecr'.
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

locals {
  # Local Purpose: Defines derived value "generated_lifecycle_policy_text" once
  # for reuse and consistent logic across this file.
  # Ternary Purpose: Selects the "selection" value by evaluating a condition
  # and choosing true/false branches explicitly.
  generated_lifecycle_policy_text = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire older images to control storage cost"
        selection = merge({
          tagStatus   = var.lifecycle_tag_status
          countType   = "imageCountMoreThan"
          countNumber = var.lifecycle_max_image_count
          }, var.lifecycle_tag_status == "tagged" ? {
          tagPrefixList = var.lifecycle_tag_prefix_list
        } : {})
        action = {
          type = "expire"
        }
      }
    ]
  })

  # Local Purpose: Defines derived value "effective_lifecycle_policy_text" once
  # for reuse and consistent logic across this file.
  # Ternary Purpose: Selects the "effective_lifecycle_policy_text" value by
  # evaluating a condition and choosing true/false branches explicitly.
  effective_lifecycle_policy_text = (
    var.lifecycle_policy_json != null
    ? var.lifecycle_policy_json
    : local.generated_lifecycle_policy_text
  )
}

# Resource Purpose: Creates an Elastic Container Registry (ECR) repository to
# store and version container images (aws_ecr_repository.this).
resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    # Ternary Purpose: Selects the "kms_key" value by evaluating a condition
    # and choosing true/false branches explicitly.
    kms_key = var.encryption_type == "KMS" ? var.kms_key_arn : null
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

# Resource Purpose: Defines a lifecycle policy for image retention and cleanup
# in Elastic Container Registry (ECR) (aws_ecr_lifecycle_policy.this).
resource "aws_ecr_lifecycle_policy" "this" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.enable_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = local.effective_lifecycle_policy_text
}

# Resource Purpose: Applies a repository policy to enforce access controls on
# Elastic Container Registry (ECR) repositories
# (aws_ecr_repository_policy.this).
resource "aws_ecr_repository_policy" "this" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.repository_policy_json != null ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy_json
}
