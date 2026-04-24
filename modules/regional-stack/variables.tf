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

# Variable Purpose: Controls "project_name" input behavior for this Terraform configuration interface.
variable "project_name" {
  description = "Project identifier."
  type        = string
}

# Variable Purpose: Controls "environment" input behavior for this Terraform configuration interface.
variable "environment" {
  description = "Environment name."
  type        = string
}

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "Region for this stack."
  type        = string
}

# Variable Purpose: Controls "vpc_cidr" input behavior for this Terraform configuration interface.
variable "vpc_cidr" {
  description = "CIDR for VPC."
  type        = string
}

# Variable Purpose: Controls "public_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
}

# Variable Purpose: Controls "private_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
}

# Variable Purpose: Controls "az_count" input behavior for this Terraform configuration interface.
variable "az_count" {
  description = "AZ count used by VPC module."
  type        = number
}

# Variable Purpose: Controls "enable_nat_gateway" input behavior for this Terraform configuration interface.
variable "enable_nat_gateway" {
  description = "Whether to provision NAT gateways."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "nat_gateway_per_az" input behavior for this Terraform configuration interface.
variable "nat_gateway_per_az" {
  description = "Whether to provision one NAT gateway per AZ."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "cluster_name" input behavior for this Terraform configuration interface.
variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

# Variable Purpose: Controls "kubernetes_version" input behavior for this Terraform configuration interface.
variable "kubernetes_version" {
  description = "Kubernetes version for EKS control plane."
  type        = string
}

# Variable Purpose: Controls "cluster_upgrade_support_type" input behavior for this Terraform configuration interface.
variable "cluster_upgrade_support_type" {
  description = "EKS cluster support type used for upgrades."
  type        = string
  default     = "STANDARD"
}

# Variable Purpose: Controls "cluster_endpoint_private_access" input behavior for this Terraform configuration interface.
variable "cluster_endpoint_private_access" {
  description = "Enable private access to EKS API endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "cluster_endpoint_public_access" input behavior for this Terraform configuration interface.
variable "cluster_endpoint_public_access" {
  description = "Enable public access to EKS API endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "cluster_endpoint_public_access_cidrs" input behavior for this Terraform configuration interface.
variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to access public EKS endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Variable Purpose: Controls "cluster_secrets_encryption_enabled" input behavior for this Terraform configuration interface.
variable "cluster_secrets_encryption_enabled" {
  description = "Enable envelope encryption for Kubernetes secrets using KMS."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "cluster_kms_key_arn" input behavior for this Terraform configuration interface.
variable "cluster_kms_key_arn" {
  description = "Optional existing KMS key ARN for EKS secrets encryption."
  type        = string
  default     = null
}

# Variable Purpose: Controls "cluster_kms_key_enable_rotation" input behavior for this Terraform configuration interface.
variable "cluster_kms_key_enable_rotation" {
  description = "Enable automatic key rotation for module-managed EKS KMS key."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "cluster_kms_key_deletion_window_in_days" input behavior for this Terraform configuration interface.
variable "cluster_kms_key_deletion_window_in_days" {
  description = "Deletion window in days for module-managed EKS KMS key."
  type        = number
  default     = 30
}

# Variable Purpose: Controls "node_instance_types" input behavior for this Terraform configuration interface.
variable "node_instance_types" {
  description = "Node group instance types."
  type        = list(string)
}

# Variable Purpose: Controls "node_capacity_type" input behavior for this Terraform configuration interface.
variable "node_capacity_type" {
  description = "Node group capacity type."
  type        = string
  default     = "SPOT"
}

# Variable Purpose: Controls "node_force_update_version" input behavior for this Terraform configuration interface.
variable "node_force_update_version" {
  description = "Force node version updates when drain operations fail."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "node_max_unavailable_percentage" input behavior for this Terraform configuration interface.
variable "node_max_unavailable_percentage" {
  description = "Max percentage of unavailable nodes during node group updates."
  type        = number
  default     = 33
}

# Variable Purpose: Controls "addon_resolve_conflicts_on_create" input behavior for this Terraform configuration interface.
variable "addon_resolve_conflicts_on_create" {
  description = "Add-on conflict resolution on create."
  type        = string
  default     = "OVERWRITE"
}

# Variable Purpose: Controls "addon_resolve_conflicts_on_update" input behavior for this Terraform configuration interface.
variable "addon_resolve_conflicts_on_update" {
  description = "Add-on conflict resolution on update."
  type        = string
  default     = "OVERWRITE"
}

# Variable Purpose: Controls "coredns_addon_version" input behavior for this Terraform configuration interface.
variable "coredns_addon_version" {
  description = "Optional pinned coredns addon version."
  type        = string
  default     = null
}

# Variable Purpose: Controls "kube_proxy_addon_version" input behavior for this Terraform configuration interface.
variable "kube_proxy_addon_version" {
  description = "Optional pinned kube-proxy addon version."
  type        = string
  default     = null
}

# Variable Purpose: Controls "vpc_cni_addon_version" input behavior for this Terraform configuration interface.
variable "vpc_cni_addon_version" {
  description = "Optional pinned vpc-cni addon version."
  type        = string
  default     = null
}

# Variable Purpose: Controls "node_desired_size" input behavior for this Terraform configuration interface.
variable "node_desired_size" {
  description = "Desired nodes."
  type        = number
}

# Variable Purpose: Controls "node_min_size" input behavior for this Terraform configuration interface.
variable "node_min_size" {
  description = "Min nodes."
  type        = number
}

# Variable Purpose: Controls "node_max_size" input behavior for this Terraform configuration interface.
variable "node_max_size" {
  description = "Max nodes."
  type        = number
}

# Variable Purpose: Controls "create_pipeline" input behavior for this Terraform configuration interface.
variable "create_pipeline" {
  description = "Whether to create CI/CD resources."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "create_codecommit_repo" input behavior for this Terraform configuration interface.
variable "create_codecommit_repo" {
  description = "Whether to create CodeCommit repository."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "codecommit_repo_name" input behavior for this Terraform configuration interface.
variable "codecommit_repo_name" {
  description = "CodeCommit repository name."
  type        = string
}

# Variable Purpose: Controls "repository_branch" input behavior for this Terraform configuration interface.
variable "repository_branch" {
  description = "Branch used by source stage."
  type        = string
  default     = "main"
}

# Variable Purpose: Controls "codebuild_image" input behavior for this Terraform configuration interface.
variable "codebuild_image" {
  description = "CodeBuild Docker image for CI/CD."
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
