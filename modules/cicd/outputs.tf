# -----------------------------------------------------------------------------
# File: modules/cicd/outputs.tf
# Purpose:
#   Publishes output contract for module 'cicd'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "pipeline_name" {
  description = "CodePipeline name."
  value       = aws_codepipeline.this.name
}

output "codebuild_project_name" {
  description = "CodeBuild project name."
  value       = aws_codebuild_project.this.name
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM role ARN."
  value       = aws_iam_role.codebuild.arn
}

output "ecr_repository_url" {
  description = "ECR repository URL."
  value       = aws_ecr_repository.app.repository_url
}

output "codecommit_repo_arn" {
  description = "CodeCommit repository ARN, null when using existing repository."
  # Ternary Purpose: Selects the "value" value by evaluating a condition and choosing true/false branches explicitly.
  value = var.create_codecommit_repo ? aws_codecommit_repository.this[0].arn : null
}
