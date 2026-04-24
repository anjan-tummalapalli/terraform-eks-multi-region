# -----------------------------------------------------------------------------
# File: modules/regional-stack/variables.tf
# Purpose:
#   Declares input interface for module 'regional-stack' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "project_name" {
  description = "Project identifier."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "region" {
  description = "Region for this stack."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
}

variable "az_count" {
  description = "AZ count used by VPC module."
  type        = number
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT gateways."
  type        = bool
  default     = true
}

variable "nat_gateway_per_az" {
  description = "Whether to provision one NAT gateway per AZ."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS control plane."
  type        = string
}

variable "cluster_upgrade_support_type" {
  description = "EKS cluster support type used for upgrades."
  type        = string
  default     = "STANDARD"
}

variable "cluster_endpoint_private_access" {
  description = "Enable private access to EKS API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Enable public access to EKS API endpoint."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to access public EKS endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_secrets_encryption_enabled" {
  description = "Enable envelope encryption for Kubernetes secrets using KMS."
  type        = bool
  default     = true
}

variable "cluster_kms_key_arn" {
  description = "Optional existing KMS key ARN for EKS secrets encryption."
  type        = string
  default     = null
}

variable "cluster_kms_key_enable_rotation" {
  description = "Enable automatic key rotation for module-managed EKS KMS key."
  type        = bool
  default     = true
}

variable "cluster_kms_key_deletion_window_in_days" {
  description = "Deletion window in days for module-managed EKS KMS key."
  type        = number
  default     = 30
}

variable "node_instance_types" {
  description = "Node group instance types."
  type        = list(string)
}

variable "node_capacity_type" {
  description = "Node group capacity type."
  type        = string
  default     = "SPOT"
}

variable "node_force_update_version" {
  description = "Force node version updates when drain operations fail."
  type        = bool
  default     = true
}

variable "node_max_unavailable_percentage" {
  description = "Max percentage of unavailable nodes during node group updates."
  type        = number
  default     = 33
}

variable "addon_resolve_conflicts_on_create" {
  description = "Add-on conflict resolution on create."
  type        = string
  default     = "OVERWRITE"
}

variable "addon_resolve_conflicts_on_update" {
  description = "Add-on conflict resolution on update."
  type        = string
  default     = "OVERWRITE"
}

variable "coredns_addon_version" {
  description = "Optional pinned coredns addon version."
  type        = string
  default     = null
}

variable "kube_proxy_addon_version" {
  description = "Optional pinned kube-proxy addon version."
  type        = string
  default     = null
}

variable "vpc_cni_addon_version" {
  description = "Optional pinned vpc-cni addon version."
  type        = string
  default     = null
}

variable "node_desired_size" {
  description = "Desired nodes."
  type        = number
}

variable "node_min_size" {
  description = "Min nodes."
  type        = number
}

variable "node_max_size" {
  description = "Max nodes."
  type        = number
}

variable "create_pipeline" {
  description = "Whether to create CI/CD resources."
  type        = bool
  default     = true
}

variable "create_codecommit_repo" {
  description = "Whether to create CodeCommit repository."
  type        = bool
  default     = true
}

variable "codecommit_repo_name" {
  description = "CodeCommit repository name."
  type        = string
}

variable "repository_branch" {
  description = "Branch used by source stage."
  type        = string
  default     = "main"
}

variable "codebuild_image" {
  description = "CodeBuild Docker image for CI/CD."
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
