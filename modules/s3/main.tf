# -----------------------------------------------------------------------------
# File: modules/s3/main.tf
# Purpose:
#   Implements resource orchestration for module 's3'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

module "bucket" {
  source = "../s3-bucket"

  bucket_name               = var.bucket_name
  versioning_enabled        = var.versioning_enabled
  sse_algorithm             = var.sse_algorithm
  kms_key_id                = var.kms_key_id
  force_destroy             = var.force_destroy
  enable_lifecycle_rule     = var.enable_lifecycle_rule
  enforce_ssl_requests      = var.enforce_ssl_requests
  object_ownership          = var.object_ownership
  lifecycle_expiration_days = var.lifecycle_expiration_days
  tags                      = var.tags
}
