# -----------------------------------------------------------------------------
# File: modules/athena/main.tf
# Purpose:
#   Implements resource orchestration for module 'athena'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Resource Purpose: Manages aws_athena_workgroup resource "this" for this module/example deployment intent.
resource "aws_athena_workgroup" "this" {
  name          = var.name
  description   = var.description
  state         = var.state
  force_destroy = var.force_destroy

  configuration {
    enforce_workgroup_configuration    = var.enforce_workgroup_configuration
    publish_cloudwatch_metrics_enabled = var.publish_cloudwatch_metrics_enabled
    requester_pays_enabled             = var.requester_pays_enabled
    bytes_scanned_cutoff_per_query     = var.bytes_scanned_cutoff_per_query

    dynamic "engine_version" {
      for_each = var.engine_version != null ? [1] : []
      content {
        selected_engine_version = var.engine_version
      }
    }

    result_configuration {
      output_location       = var.result_output_location
      expected_bucket_owner = var.expected_bucket_owner

      encryption_configuration {
        encryption_option = var.result_encryption_option
        kms_key_arn       = var.result_encryption_option == "SSE_KMS" ? var.result_kms_key_arn : null
      }
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

# Resource Purpose: Manages aws_athena_database resource "this" for this module/example deployment intent.
resource "aws_athena_database" "this" {
  count = var.create_database ? 1 : 0

  name                  = var.database_name
  bucket                = var.database_bucket
  comment               = var.database_comment
  expected_bucket_owner = var.expected_bucket_owner
  force_destroy         = var.database_force_destroy

  dynamic "encryption_configuration" {
    for_each = var.database_encryption_option != null ? [1] : []
    content {
      encryption_option = var.database_encryption_option
      kms_key           = var.database_encryption_option == "SSE_KMS" ? var.database_kms_key_arn : null
    }
  }
}
