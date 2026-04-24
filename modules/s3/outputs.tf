# -----------------------------------------------------------------------------
# File: modules/s3/outputs.tf
# Purpose:
#   Publishes output contract for module 's3'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "bucket_id" {
  description = "S3 bucket ID."
  value       = module.bucket.bucket_id
}

output "bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.bucket.bucket_arn
}
