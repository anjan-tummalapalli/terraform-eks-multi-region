# -----------------------------------------------------------------------------
# File: examples/bedrock-basic/main.tf
# Purpose:
#   Demonstrates end-to-end usage for example 'bedrock-basic'.
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

module "bedrock_logs_bucket" {
  source = "../../modules/s3"

  bucket_name               = var.bedrock_logs_bucket_name
  versioning_enabled        = false
  sse_algorithm             = "AES256"
  enforce_ssl_requests      = true
  enable_lifecycle_rule     = true
  lifecycle_expiration_days = 30
  tags                      = var.tags
}

module "bedrock" {
  source = "../../modules/bedrock"

  name_prefix = var.name_prefix

  enable_cloudwatch_logging        = true
  create_cloudwatch_log_group      = true
  cloudwatch_log_retention_in_days = 7

  create_logging_role = true

  s3_bucket_name = module.bedrock_logs_bucket.bucket_id
  s3_key_prefix  = "bedrock/invocations/"

  text_data_delivery_enabled      = true
  image_data_delivery_enabled     = false
  embedding_data_delivery_enabled = false
  video_data_delivery_enabled     = false

  tags = var.tags
}
