# -----------------------------------------------------------------------------
# File: examples/athena-basic/main.tf
# Purpose:
#   Demonstrates end-to-end usage for example 'athena-basic'.
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

# Data Purpose: Reads aws_caller_identity data source "current" to reference existing AWS metadata/resources required by this configuration.
data "aws_caller_identity" "current" {}

module "results_bucket" {
  source = "../../modules/s3"

  bucket_name               = var.athena_results_bucket_name
  versioning_enabled        = false
  sse_algorithm             = "AES256"
  force_destroy             = false
  enable_lifecycle_rule     = true
  lifecycle_expiration_days = 30
  enforce_ssl_requests      = true
  tags                      = var.tags
}

module "athena" {
  source = "../../modules/athena"

  name                               = "${var.name_prefix}-wg"
  description                        = "Cost-optimized Athena workgroup"
  result_output_location             = "s3://${module.results_bucket.bucket_id}/query-results/"
  result_encryption_option           = "SSE_S3"
  expected_bucket_owner              = data.aws_caller_identity.current.account_id
  enforce_workgroup_configuration    = true
  publish_cloudwatch_metrics_enabled = true
  bytes_scanned_cutoff_per_query     = var.bytes_scanned_cutoff_per_query

  create_database = true
  database_name   = var.database_name

  tags = var.tags
}
