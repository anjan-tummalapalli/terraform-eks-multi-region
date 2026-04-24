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

# Resource Purpose: Configures an Athena workgroup for query execution settings, output location, and scan controls (aws_athena_workgroup.this).
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

    # Dynamic Purpose: Adds an engine_version block only when an explicit Athena engine version is provided.
    dynamic "engine_version" {
      # Ternary Purpose: Selects the "for_each" value by evaluating a condition and choosing true/false branches explicitly.
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
        # Ternary Purpose: Selects the "kms_key_arn" value by evaluating a condition and choosing true/false branches explicitly.
        kms_key_arn = var.result_encryption_option == "SSE_KMS" ? var.result_kms_key_arn : null
      }
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

# Resource Purpose: Creates an Athena database container for table metadata and query namespaces (aws_athena_database.this).
resource "aws_athena_database" "this" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and choosing true/false branches explicitly.
  count = var.create_database ? 1 : 0

  name                  = var.database_name
  bucket                = var.database_bucket
  comment               = var.database_comment
  expected_bucket_owner = var.expected_bucket_owner
  force_destroy         = var.database_force_destroy

  # Dynamic Purpose: Adds database encryption settings only when database-level encryption is requested.
  dynamic "encryption_configuration" {
    # Ternary Purpose: Selects the "for_each" value by evaluating a condition and choosing true/false branches explicitly.
    for_each = var.database_encryption_option != null ? [1] : []
    content {
      encryption_option = var.database_encryption_option
      # Ternary Purpose: Selects the "kms_key" value by evaluating a condition and choosing true/false branches explicitly.
      kms_key = var.database_encryption_option == "SSE_KMS" ? var.database_kms_key_arn : null
    }
  }
}
