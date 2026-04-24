# -----------------------------------------------------------------------------
# File: modules/regional-stack/variables.tf
# Purpose:
#   Declares input interface for module 'regional-stack' (types, defaults,
# validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so
# callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Project identifier.
variable "project_name" {
  description = "Project identifier."
  type        = string
}

# Variable Purpose: Environment name.
variable "environment" {
  description = "Environment name."
  type        = string
}

# Variable Purpose: Region for this stack.
variable "region" {
  description = "Region for this stack."
  type        = string
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) for Virtual Private
# Cloud (VPC).
variable "vpc_cidr" {
  description = "CIDR for VPC."
  type        = string
}

# Variable Purpose: Public subnet Classless Inter-Domain Routing blocks (CIDRs).
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
}

# Variable Purpose: Private subnet Classless Inter-Domain Routing blocks
# (CIDRs).
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
}

# Variable Purpose: Availability Zone (AZ) count used by Virtual Private Cloud
# (VPC) module.
variable "az_count" {
  description = "AZ count used by VPC module."
  type        = number
}

# Variable Purpose: Whether to provision Network Address Translation (NAT)
# gateways.
variable "enable_nat_gateway" {
  description = "Whether to provision NAT gateways."
  type        = bool
  default     = true
}

# Variable Purpose: Whether to provision one Network Address Translation (NAT)
# gateway per Availability Zone (AZ).
variable "nat_gateway_per_az" {
  description = "Whether to provision one NAT gateway per AZ."
  type        = bool
  default     = false
}

# Variable Purpose: Elastic Kubernetes Service (EKS) cluster name.
variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

# Variable Purpose: Kubernetes version for Elastic Kubernetes Service (EKS)
# control plane.
variable "kubernetes_version" {
  description = "Kubernetes version for EKS control plane."
  type        = string
}

# Variable Purpose: Elastic Kubernetes Service (EKS) cluster support type used
# for upgrades.
variable "cluster_upgrade_support_type" {
  description = "EKS cluster support type used for upgrades."
  type        = string
  default     = "STANDARD"
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
# access public Elastic Kubernetes Service (EKS) endpoint.
variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to access public EKS endpoint."
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
}

# Variable Purpose: Node group instance types.
variable "node_instance_types" {
  description = "Node group instance types."
  type        = list(string)
}

# Variable Purpose: Node group capacity type.
variable "node_capacity_type" {
  description = "Node group capacity type."
  type        = string
  default     = "SPOT"
}

# Variable Purpose: Force node version updates when drain operations fail.
variable "node_force_update_version" {
  description = "Force node version updates when drain operations fail."
  type        = bool
  default     = true
}

# Variable Purpose: Max percentage of unavailable nodes during node group
# updates.
variable "node_max_unavailable_percentage" {
  description = "Max percentage of unavailable nodes during node group updates."
  type        = number
  default     = 33
}

# Variable Purpose: Add-on conflict resolution on create.
variable "addon_resolve_conflicts_on_create" {
  description = "Add-on conflict resolution on create."
  type        = string
  default     = "OVERWRITE"
}

# Variable Purpose: Add-on conflict resolution on update.
variable "addon_resolve_conflicts_on_update" {
  description = "Add-on conflict resolution on update."
  type        = string
  default     = "OVERWRITE"
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

# Variable Purpose: Desired nodes.
variable "node_desired_size" {
  description = "Desired nodes."
  type        = number
}

# Variable Purpose: Min nodes.
variable "node_min_size" {
  description = "Min nodes."
  type        = number
}

# Variable Purpose: Max nodes.
variable "node_max_size" {
  description = "Max nodes."
  type        = number
}

# Variable Purpose: Whether to create Continuous Integration and Continuous
# Delivery (CI/CD) resources.
variable "create_pipeline" {
  description = "Whether to create CI/CD resources."
  type        = bool
  default     = true
}

# Variable Purpose: Whether to create CodeCommit repository.
variable "create_codecommit_repo" {
  description = "Whether to create CodeCommit repository."
  type        = bool
  default     = true
}

# Variable Purpose: CodeCommit repository name.
variable "codecommit_repo_name" {
  description = "CodeCommit repository name."
  type        = string
}

# Variable Purpose: Branch used by source stage.
variable "repository_branch" {
  description = "Branch used by source stage."
  type        = string
  default     = "main"
}

# Variable Purpose: CodeBuild Docker image for Continuous Integration and
# Continuous Delivery (CI/CD).
variable "codebuild_image" {
  description = "CodeBuild Docker image for CI/CD."
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
