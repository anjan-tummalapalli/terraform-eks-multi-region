# -----------------------------------------------------------------------------
# File: examples/ecr-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'ecr-basic'.
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

output "repository_name" {
  description = "Elastic Container Registry (ECR) repository name."
  value       = module.ecr.repository_name
}

output "repository_arn" {
  description = <<-EOT
    Elastic Container Registry (ECR) repository Amazon Resource Name (ARN).
  EOT
  value       = module.ecr.repository_arn
}

output "repository_url" {
  description = <<-EOT
    Elastic Container Registry (ECR) repository URI used for image push/pull
    operations.
  EOT
  value       = module.ecr.repository_url
}

output "lifecycle_policy_text" {
  description = <<-EOT
    Lifecycle policy JSON text currently applied to this repository.
  EOT
  value       = module.ecr.lifecycle_policy_text
}
