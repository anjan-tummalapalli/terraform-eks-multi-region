# -----------------------------------------------------------------------------
# File: examples/kms-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'kms-basic'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

output "kms_key_arn" {
  description = "KMS key ARN used for encryption."
  value       = module.kms.key_arn
}

output "kms_aliases" {
  description = "Aliases created for KMS key."
  value       = module.kms.all_alias_names
}

output "s3_bucket_arn" {
  description = "Encrypted S3 bucket ARN."
  value       = module.secure_bucket.bucket_arn
}
