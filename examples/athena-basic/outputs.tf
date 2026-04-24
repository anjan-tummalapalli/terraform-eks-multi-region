# -----------------------------------------------------------------------------
# File: examples/athena-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'athena-basic'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "athena_workgroup_name" {
  description = "Athena workgroup name."
  value       = module.athena.workgroup_name
}

output "athena_database_name" {
  description = "Athena database name."
  value       = module.athena.database_name
}

output "athena_results_bucket" {
  description = "S3 bucket used for Athena results."
  value       = module.results_bucket.bucket_id
}
