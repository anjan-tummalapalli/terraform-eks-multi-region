variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "region" {
  description = "Region where CI/CD resources are provisioned."
  type        = string
}

variable "cluster_name" {
  description = "Target EKS cluster name."
  type        = string
}

variable "codecommit_repo_name" {
  description = "CodeCommit repository name for source stage."
  type        = string
}

variable "create_codecommit_repo" {
  description = "Whether this module creates CodeCommit repository."
  type        = bool
  default     = true
}

variable "repository_branch" {
  description = "Branch used by CodePipeline source stage."
  type        = string
  default     = "main"
}

variable "codebuild_image" {
  description = "CodeBuild Docker image used for pipeline builds."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

variable "codebuild_compute_type" {
  description = "CodeBuild compute size."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
