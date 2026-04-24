# -----------------------------------------------------------------------------
# File: modules/cicd/variables.tf
# Purpose:
#   Declares input interface for module 'cicd' (types, defaults, validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Project name used for resource naming.
variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

# Variable Purpose: Environment name.
variable "environment" {
  description = "Environment name."
  type        = string
}

# Variable Purpose: Region where Continuous Integration and Continuous Delivery (CI/CD) resources are provisioned.
variable "region" {
  description = "Region where CI/CD resources are provisioned."
  type        = string
}

# Variable Purpose: Target Elastic Kubernetes Service (EKS) cluster name.
variable "cluster_name" {
  description = "Target EKS cluster name."
  type        = string
}

# Variable Purpose: CodeCommit repository name for source stage.
variable "codecommit_repo_name" {
  description = "CodeCommit repository name for source stage."
  type        = string
}

# Variable Purpose: Whether this module creates CodeCommit repository.
variable "create_codecommit_repo" {
  description = "Whether this module creates CodeCommit repository."
  type        = bool
  default     = true
}

# Variable Purpose: Branch used by CodePipeline source stage.
variable "repository_branch" {
  description = "Branch used by CodePipeline source stage."
  type        = string
  default     = "main"
}

# Variable Purpose: CodeBuild Docker image used for pipeline builds.
variable "codebuild_image" {
  description = "CodeBuild Docker image used for pipeline builds."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

# Variable Purpose: CodeBuild compute size.
variable "codebuild_compute_type" {
  description = "CodeBuild compute size."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
