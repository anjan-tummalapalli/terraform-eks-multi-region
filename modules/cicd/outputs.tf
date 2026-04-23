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
  value       = var.create_codecommit_repo ? aws_codecommit_repository.this[0].arn : null
}
