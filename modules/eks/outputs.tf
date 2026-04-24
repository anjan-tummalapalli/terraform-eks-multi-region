# -----------------------------------------------------------------------------
# File: modules/eks/outputs.tf
# Purpose:
#   Publishes output contract for module 'eks'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_arn" {
  description = "EKS cluster ARN."
  value       = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {
  description = "EKS API endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_version" {
  description = "EKS control plane version."
  value       = aws_eks_cluster.this.version
}

output "cluster_security_group_id" {
  description = "Control plane security group ID."
  value       = aws_security_group.cluster.id
}

output "cluster_kms_key_arn" {
  description = "KMS key ARN used for EKS secrets encryption, null when disabled."
  value       = var.cluster_secrets_encryption_enabled ? local.cluster_kms_key_arn : null
}
