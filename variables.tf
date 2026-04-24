# -----------------------------------------------------------------------------
# File: variables.tf
# Purpose:
#   Defines root-module input interface and defaults.
# Why this file exists:
#   Keeps deployment customization explicit, reviewable, and validation-friendly.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "project_name" {
  description = "Project identifier used in resource naming."
  type        = string
  default     = "platform"
}

variable "environment" {
  description = "Environment name (e.g., dev, stage, prod)."
  type        = string
  default     = "prod"
}

variable "aws_profile" {
  description = "Optional AWS profile name. Leave empty to use default credentials chain."
  type        = string
  default     = ""
}

variable "primary_region" {
  description = "Primary AWS region for active workloads."
  type        = string
  default     = "ap-south-1"
}

variable "dr_region" {
  description = "Disaster recovery AWS region."
  type        = string
  default     = "ap-southeast-1"
}

variable "primary_vpc_cidr" {
  description = "CIDR block for the primary region VPC."
  type        = string
  default     = "10.10.0.0/16"
}

variable "primary_public_subnet_cidrs" {
  description = "Public subnet CIDRs in primary region."
  type        = list(string)
  default     = ["10.10.0.0/24", "10.10.1.0/24"]
}

variable "primary_private_subnet_cidrs" {
  description = "Private subnet CIDRs in primary region."
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.11.0/24"]
}

variable "dr_vpc_cidr" {
  description = "CIDR block for the DR region VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "dr_public_subnet_cidrs" {
  description = "Public subnet CIDRs in DR region."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
}

variable "dr_private_subnet_cidrs" {
  description = "Private subnet CIDRs in DR region."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]
}

variable "az_count" {
  description = "Number of Availability Zones used per region."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2
    error_message = "Use at least 2 AZs for high availability."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway resources for private subnet egress."
  type        = bool
  default     = true
}

variable "nat_gateway_per_az" {
  description = "Whether to create one NAT Gateway per AZ for higher availability (higher cost)."
  type        = bool
  default     = false
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.29"
}

variable "cluster_upgrade_support_type" {
  description = "EKS cluster support type for control plane upgrades."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.cluster_upgrade_support_type)
    error_message = "cluster_upgrade_support_type must be STANDARD or EXTENDED."
  }
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
  description = "CIDR blocks allowed to access the public EKS API endpoint."
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

  validation {
    condition     = var.cluster_kms_key_deletion_window_in_days >= 7 && var.cluster_kms_key_deletion_window_in_days <= 30
    error_message = "cluster_kms_key_deletion_window_in_days must be between 7 and 30."
  }
}

variable "node_instance_types" {
  description = "EKS managed node group instance types (cost-optimized baseline)."
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_capacity_type" {
  description = "Node group capacity type: SPOT (cost optimized) or ON_DEMAND."
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["SPOT", "ON_DEMAND"], var.node_capacity_type)
    error_message = "node_capacity_type must be SPOT or ON_DEMAND."
  }
}

variable "node_force_update_version" {
  description = "Force EKS managed node group version updates when drain operations fail."
  type        = bool
  default     = true
}

variable "node_max_unavailable_percentage" {
  description = "Maximum percentage of nodes unavailable during upgrades."
  type        = number
  default     = 33

  validation {
    condition     = var.node_max_unavailable_percentage >= 1 && var.node_max_unavailable_percentage <= 100
    error_message = "node_max_unavailable_percentage must be between 1 and 100."
  }
}

variable "addon_resolve_conflicts_on_create" {
  description = "Conflict handling for EKS addon creation."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.addon_resolve_conflicts_on_create)
    error_message = "addon_resolve_conflicts_on_create must be NONE or OVERWRITE."
  }
}

variable "addon_resolve_conflicts_on_update" {
  description = "Conflict handling for EKS addon upgrades."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE", "PRESERVE"], var.addon_resolve_conflicts_on_update)
    error_message = "addon_resolve_conflicts_on_update must be NONE, OVERWRITE, or PRESERVE."
  }
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

variable "primary_node_desired_size" {
  description = "Desired number of worker nodes in primary region."
  type        = number
  default     = 2
}

variable "primary_node_min_size" {
  description = "Minimum number of worker nodes in primary region."
  type        = number
  default     = 1
}

variable "primary_node_max_size" {
  description = "Maximum number of worker nodes in primary region."
  type        = number
  default     = 3
}

variable "dr_node_desired_size" {
  description = "Desired number of worker nodes in DR region."
  type        = number
  default     = 1
}

variable "dr_node_min_size" {
  description = "Minimum number of worker nodes in DR region."
  type        = number
  default     = 1
}

variable "dr_node_max_size" {
  description = "Maximum number of worker nodes in DR region."
  type        = number
  default     = 2
}

variable "repository_branch" {
  description = "Source branch used by CodePipeline."
  type        = string
  default     = "main"
}

variable "codebuild_image" {
  description = "CodeBuild Docker image used by pipelines."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

variable "codebuild_compute_type" {
  description = "CodeBuild compute size used by pipelines."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "create_codecommit_repo" {
  description = "Whether to create a CodeCommit repository in each region."
  type        = bool
  default     = true
}

variable "primary_codecommit_repo_name" {
  description = "CodeCommit repository name for primary region pipeline."
  type        = string
  default     = "eks-app-primary"
}

variable "dr_codecommit_repo_name" {
  description = "CodeCommit repository name for DR region pipeline."
  type        = string
  default     = "eks-app-dr"
}

variable "enable_dr_pipeline" {
  description = "Whether to create CI/CD resources in DR region too (set false to save cost)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags added to all resources."
  type        = map(string)
  default     = {}
}
