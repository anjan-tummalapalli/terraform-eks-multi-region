# -----------------------------------------------------------------------------
# File: modules/regional-stack/outputs.tf
# Purpose:
#   Publishes output contract for module 'regional-stack'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "VPC ID for the regional stack."
  value       = module.vpc.vpc_id
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_version" {
  description = "EKS control plane version."
  value       = module.eks.cluster_version
}

output "cluster_kms_key_arn" {
  description = "KMS key ARN used for EKS secrets encryption."
  value       = module.eks.cluster_kms_key_arn
}

output "ecr_repository_url" {
  description = "ECR URL for app image."
  value       = var.create_pipeline ? module.cicd[0].ecr_repository_url : null
}

output "codepipeline_name" {
  description = "Pipeline name."
  value       = var.create_pipeline ? module.cicd[0].pipeline_name : null
}

output "codecommit_repo_arn" {
  description = "CodeCommit repository ARN when repository is created in this module."
  value       = var.create_pipeline ? module.cicd[0].codecommit_repo_arn : null
}
