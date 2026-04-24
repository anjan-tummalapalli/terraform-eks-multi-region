# -----------------------------------------------------------------------------
# File: modules/ecr/outputs.tf
# Purpose:
#   Publishes output contract for module 'ecr'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal
# resource implementation details.
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
  value       = aws_ecr_repository.this.name
}

output "repository_arn" {
  description = <<-EOT
    Elastic Container Registry (ECR) repository Amazon Resource Name (ARN).
  EOT
  value       = aws_ecr_repository.this.arn
}

output "repository_url" {
  description = <<-EOT
    Elastic Container Registry (ECR) repository URI used for image push/pull
    operations.
  EOT
  value       = aws_ecr_repository.this.repository_url
}

output "registry_id" {
  description = <<-EOT
    Elastic Container Registry (ECR) registry ID owning this repository.
  EOT
  value       = aws_ecr_repository.this.registry_id
}

output "lifecycle_policy_text" {
  description = <<-EOT
    Lifecycle policy JSON text applied to the repository, or null when
    lifecycle policy creation is disabled.
  EOT
  value = (
    var.enable_lifecycle_policy ? local.effective_lifecycle_policy_text : null
  )
}
