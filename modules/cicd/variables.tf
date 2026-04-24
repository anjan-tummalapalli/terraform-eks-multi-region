# -----------------------------------------------------------------------------
# File: modules/cicd/variables.tf
# Purpose:
#   Declares input interface for module 'cicd' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "project_name" input behavior for this Terraform configuration interface.
variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

# Variable Purpose: Controls "environment" input behavior for this Terraform configuration interface.
variable "environment" {
  description = "Environment name."
  type        = string
}

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "Region where CI/CD resources are provisioned."
  type        = string
}

# Variable Purpose: Controls "cluster_name" input behavior for this Terraform configuration interface.
variable "cluster_name" {
  description = "Target EKS cluster name."
  type        = string
}

# Variable Purpose: Controls "codecommit_repo_name" input behavior for this Terraform configuration interface.
variable "codecommit_repo_name" {
  description = "CodeCommit repository name for source stage."
  type        = string
}

# Variable Purpose: Controls "create_codecommit_repo" input behavior for this Terraform configuration interface.
variable "create_codecommit_repo" {
  description = "Whether this module creates CodeCommit repository."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "repository_branch" input behavior for this Terraform configuration interface.
variable "repository_branch" {
  description = "Branch used by CodePipeline source stage."
  type        = string
  default     = "main"
}

# Variable Purpose: Controls "codebuild_image" input behavior for this Terraform configuration interface.
variable "codebuild_image" {
  description = "CodeBuild Docker image used for pipeline builds."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

# Variable Purpose: Controls "codebuild_compute_type" input behavior for this Terraform configuration interface.
variable "codebuild_compute_type" {
  description = "CodeBuild compute size."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
