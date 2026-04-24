# -----------------------------------------------------------------------------
# File: variables.tf
# Purpose:
#   Defines root-module input interface and defaults.
# Why this file exists:
#   Keeps deployment customization explicit, reviewable, and
# validation-friendly.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Project identifier used in resource naming.
variable "project_name" {
  description = "Project identifier used in resource naming."
  type        = string
  default     = "platform"
}

# Variable Purpose: Environment name (e.g., dev, stage, prod).
variable "environment" {
  description = "Environment name (e.g., dev, stage, prod)."
  type        = string
  default     = "prod"
}

# Variable Purpose: Optional Amazon Web Services (AWS) profile name. Leave
# empty to use default credentials chain.
variable "aws_profile" {
  description = <<-EOT
    Optional AWS profile name. Leave empty to use default credentials chain.
  EOT
  type        = string
  default     = ""
}

# Variable Purpose: Primary Amazon Web Services (AWS) region for active
# workloads.
variable "primary_region" {
  description = "Primary AWS region for active workloads."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Disaster recovery Amazon Web Services (AWS) region.
variable "dr_region" {
  description = "Disaster recovery AWS region."
  type        = string
  default     = "ap-southeast-1"
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) block for the primary
# region Virtual Private Cloud (VPC).
variable "primary_vpc_cidr" {
  description = "CIDR block for the primary region VPC."
  type        = string
  default     = "10.10.0.0/16"
}

# Variable Purpose: Public subnet Classless Inter-Domain Routing blocks (CIDRs)
# in primary region.
variable "primary_public_subnet_cidrs" {
  description = "Public subnet CIDRs in primary region."
  type        = list(string)
  default     = ["10.10.0.0/24", "10.10.1.0/24"]
}

# Variable Purpose: Private subnet Classless Inter-Domain Routing blocks
# (CIDRs) in primary region.
variable "primary_private_subnet_cidrs" {
  description = "Private subnet CIDRs in primary region."
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.11.0/24"]
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) block for the
# Disaster Recovery (DR) region Virtual Private Cloud (VPC).
variable "dr_vpc_cidr" {
  description = "CIDR block for the DR region VPC."
  type        = string
  default     = "10.20.0.0/16"
}

# Variable Purpose: Public subnet Classless Inter-Domain Routing blocks (CIDRs)
# in Disaster Recovery (DR) region.
variable "dr_public_subnet_cidrs" {
  description = "Public subnet CIDRs in DR region."
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
}

# Variable Purpose: Private subnet Classless Inter-Domain Routing blocks
# (CIDRs) in Disaster Recovery (DR) region.
variable "dr_private_subnet_cidrs" {
  description = "Private subnet CIDRs in DR region."
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24"]
}

# Variable Purpose: Number of Availability Zones used per region.
variable "az_count" {
  description = "Number of Availability Zones used per region."
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2
    error_message = "Use at least 2 AZs for high availability."
  }
}

# Variable Purpose: Whether to create Network Address Translation (NAT) Gateway
# resources for private subnet egress.
variable "enable_nat_gateway" {
  description = <<-EOT
    Whether to create NAT Gateway resources for private subnet egress.
  EOT
  type        = bool
  default     = true
}

# Variable Purpose: Whether to create one Network Address Translation (NAT)
# Gateway per Availability Zone (AZ) for higher availability (higher cost).
variable "nat_gateway_per_az" {
  description = <<-EOT
    Whether to create one NAT Gateway per AZ for higher availability (higher
    cost).
  EOT
  type        = bool
  default     = false
}

# Variable Purpose: Elastic Kubernetes Service (EKS) Kubernetes version.
variable "kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.29"
}

# Variable Purpose: Elastic Kubernetes Service (EKS) cluster support type for
# control plane upgrades.
variable "cluster_upgrade_support_type" {
  description = "EKS cluster support type for control plane upgrades."
  type        = string
  default     = "STANDARD"

  validation {
    condition = (
      contains(["STANDARD", "EXTENDED"], var.cluster_upgrade_support_type)
    )
    error_message = "cluster_upgrade_support_type must be STANDARD or EXTENDED."
  }
}

# Variable Purpose: Enable private access to Elastic Kubernetes Service (EKS)
# Application Programming Interface (API) endpoint.
variable "cluster_endpoint_private_access" {
  description = "Enable private access to EKS API endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Enable public access to Elastic Kubernetes Service (EKS)
# Application Programming Interface (API) endpoint.
variable "cluster_endpoint_public_access" {
  description = "Enable public access to EKS API endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) blocks allowed to
# access the public Elastic Kubernetes Service (EKS) Application Programming
# Interface (API) endpoint.
variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to access the public EKS API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Variable Purpose: Enable envelope encryption for Kubernetes secrets using Key
# Management Service (KMS).
variable "cluster_secrets_encryption_enabled" {
  description = "Enable envelope encryption for Kubernetes secrets using KMS."
  type        = bool
  default     = true
}

# Variable Purpose: Optional existing Key Management Service (KMS) key Amazon
# Resource Name (ARN) for Elastic Kubernetes Service (EKS) secrets encryption.
variable "cluster_kms_key_arn" {
  description = "Optional existing KMS key ARN for EKS secrets encryption."
  type        = string
  default     = null
}

# Variable Purpose: Enable automatic key rotation for module-managed Elastic
# Kubernetes Service (EKS) Key Management Service (KMS) key.
variable "cluster_kms_key_enable_rotation" {
  description = "Enable automatic key rotation for module-managed EKS KMS key."
  type        = bool
  default     = true
}

# Variable Purpose: Deletion window in days for module-managed Elastic
# Kubernetes Service (EKS) Key Management Service (KMS) key.
variable "cluster_kms_key_deletion_window_in_days" {
  description = "Deletion window in days for module-managed EKS KMS key."
  type        = number
  default     = 30

  validation {
    condition = (
      var.cluster_kms_key_deletion_window_in_days >= 7 &&
      var.cluster_kms_key_deletion_window_in_days <= 30
    )
    error_message = <<-EOT
      cluster_kms_key_deletion_window_in_days must be between 7 and 30.
    EOT
  }
}

# Variable Purpose: Elastic Kubernetes Service (EKS) managed node group
# instance types (cost-optimized baseline).
variable "node_instance_types" {
  description = <<-EOT
    EKS managed node group instance types (cost-optimized baseline).
  EOT
  type        = list(string)
  default     = ["t3.small"]
}

# Variable Purpose: Node group capacity type: SPOT (cost optimized) or
# ON_DEMAND.
variable "node_capacity_type" {
  description = "Node group capacity type: SPOT (cost optimized) or ON_DEMAND."
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["SPOT", "ON_DEMAND"], var.node_capacity_type)
    error_message = "node_capacity_type must be SPOT or ON_DEMAND."
  }
}

# Variable Purpose: Force Elastic Kubernetes Service (EKS) managed node group
# version updates when drain operations fail.
variable "node_force_update_version" {
  description = <<-EOT
    Force EKS managed node group version updates when drain operations fail.
  EOT
  type        = bool
  default     = true
}

# Variable Purpose: Maximum percentage of nodes unavailable during upgrades.
variable "node_max_unavailable_percentage" {
  description = "Maximum percentage of nodes unavailable during upgrades."
  type        = number
  default     = 33

  validation {
    condition = (
      var.node_max_unavailable_percentage >= 1 &&
      var.node_max_unavailable_percentage <= 100
    )
    error_message = "node_max_unavailable_percentage must be between 1 and 100."
  }
}

# Variable Purpose: Conflict handling for Elastic Kubernetes Service (EKS)
# addon creation.
variable "addon_resolve_conflicts_on_create" {
  description = "Conflict handling for EKS addon creation."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition = (
      contains(["NONE", "OVERWRITE"], var.addon_resolve_conflicts_on_create)
    )
    error_message = <<-EOT
      addon_resolve_conflicts_on_create must be NONE or OVERWRITE.
    EOT
  }
}

# Variable Purpose: Conflict handling for Elastic Kubernetes Service (EKS)
# addon upgrades.
variable "addon_resolve_conflicts_on_update" {
  description = "Conflict handling for EKS addon upgrades."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition = (
      contains(
        ["NONE", "OVERWRITE", "PRESERVE"],
        var.addon_resolve_conflicts_on_update
      )
    )
    error_message = <<-EOT
      addon_resolve_conflicts_on_update must be NONE, OVERWRITE, or PRESERVE.
    EOT
  }
}

# Variable Purpose: Optional pinned coredns addon version.
variable "coredns_addon_version" {
  description = "Optional pinned coredns addon version."
  type        = string
  default     = null
}

# Variable Purpose: Optional pinned kube-proxy addon version.
variable "kube_proxy_addon_version" {
  description = "Optional pinned kube-proxy addon version."
  type        = string
  default     = null
}

# Variable Purpose: Optional pinned vpc-cni addon version.
variable "vpc_cni_addon_version" {
  description = "Optional pinned vpc-cni addon version."
  type        = string
  default     = null
}

# Variable Purpose: Desired number of worker nodes in primary region.
variable "primary_node_desired_size" {
  description = "Desired number of worker nodes in primary region."
  type        = number
  default     = 2
}

# Variable Purpose: Minimum number of worker nodes in primary region.
variable "primary_node_min_size" {
  description = "Minimum number of worker nodes in primary region."
  type        = number
  default     = 1
}

# Variable Purpose: Maximum number of worker nodes in primary region.
variable "primary_node_max_size" {
  description = "Maximum number of worker nodes in primary region."
  type        = number
  default     = 3
}

# Variable Purpose: Desired number of worker nodes in Disaster Recovery (DR)
# region.
variable "dr_node_desired_size" {
  description = "Desired number of worker nodes in DR region."
  type        = number
  default     = 1
}

# Variable Purpose: Minimum number of worker nodes in Disaster Recovery (DR)
# region.
variable "dr_node_min_size" {
  description = "Minimum number of worker nodes in DR region."
  type        = number
  default     = 1
}

# Variable Purpose: Maximum number of worker nodes in Disaster Recovery (DR)
# region.
variable "dr_node_max_size" {
  description = "Maximum number of worker nodes in DR region."
  type        = number
  default     = 2
}

# Variable Purpose: Source branch used by CodePipeline.
variable "repository_branch" {
  description = "Source branch used by CodePipeline."
  type        = string
  default     = "main"
}

# Variable Purpose: CodeBuild Docker image used by pipelines.
variable "codebuild_image" {
  description = "CodeBuild Docker image used by pipelines."
  type        = string
  default     = "aws/codebuild/standard:7.0"
}

# Variable Purpose: CodeBuild compute size used by pipelines.
variable "codebuild_compute_type" {
  description = "CodeBuild compute size used by pipelines."
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

# Variable Purpose: Whether to create a CodeCommit repository in each region.
variable "create_codecommit_repo" {
  description = "Whether to create a CodeCommit repository in each region."
  type        = bool
  default     = true
}

# Variable Purpose: CodeCommit repository name for primary region pipeline.
variable "primary_codecommit_repo_name" {
  description = "CodeCommit repository name for primary region pipeline."
  type        = string
  default     = "eks-app-primary"
}

# Variable Purpose: CodeCommit repository name for Disaster Recovery (DR)
# region pipeline.
variable "dr_codecommit_repo_name" {
  description = "CodeCommit repository name for DR region pipeline."
  type        = string
  default     = "eks-app-dr"
}

# Variable Purpose: Whether to create Continuous Integration and Continuous
# Delivery (CI/CD) resources in Disaster Recovery (DR) region too (set false to
# save cost).
variable "enable_dr_pipeline" {
  description = <<-EOT
    Whether to create CI/CD resources in DR region too (set false to save
    cost).
  EOT
  type        = bool
  default     = false
}

# Variable Purpose: Additional tags added to all resources.
variable "tags" {
  description = "Additional tags added to all resources."
  type        = map(string)
  default     = {}
}
