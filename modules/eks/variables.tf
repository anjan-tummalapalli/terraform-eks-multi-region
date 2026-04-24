# -----------------------------------------------------------------------------
# File: modules/eks/variables.tf
# Purpose:
#   Declares input interface for module 'eks' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

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
  description = "EKS upgrade support type for the control plane."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.cluster_upgrade_support_type)
    error_message = "cluster_upgrade_support_type must be STANDARD or EXTENDED."
  }
}

# Variable Purpose: Controls "cluster_endpoint_private_access" input behavior for this Terraform configuration interface.
variable "cluster_endpoint_private_access" {
  description = "Enable private access to the Kubernetes API server endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "cluster_endpoint_public_access" input behavior for this Terraform configuration interface.
variable "cluster_endpoint_public_access" {
  description = "Enable public access to the Kubernetes API server endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "cluster_endpoint_public_access_cidrs" input behavior for this Terraform configuration interface.
variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks that can access the public EKS endpoint."
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

  validation {
    condition     = var.cluster_kms_key_deletion_window_in_days >= 7 && var.cluster_kms_key_deletion_window_in_days <= 30
    error_message = "cluster_kms_key_deletion_window_in_days must be between 7 and 30."
  }
}

# Variable Purpose: Controls "vpc_id" input behavior for this Terraform configuration interface.
variable "vpc_id" {
  description = "VPC ID for cluster networking."
  type        = string
}

# Variable Purpose: Controls "private_subnet_ids" input behavior for this Terraform configuration interface.
variable "private_subnet_ids" {
  description = "Private subnet IDs for worker nodes."
  type        = list(string)
}

# Variable Purpose: Controls "cluster_role_arn" input behavior for this Terraform configuration interface.
variable "cluster_role_arn" {
  description = "IAM role ARN for EKS control plane."
  type        = string
}

# Variable Purpose: Controls "node_role_arn" input behavior for this Terraform configuration interface.
variable "node_role_arn" {
  description = "IAM role ARN for EKS managed node group."
  type        = string
}

# Variable Purpose: Controls "node_instance_types" input behavior for this Terraform configuration interface.
variable "node_instance_types" {
  description = "Instance types for worker nodes."
  type        = list(string)
  default     = ["t3.small"]
}

# Variable Purpose: Controls "node_desired_size" input behavior for this Terraform configuration interface.
variable "node_desired_size" {
  description = "Desired size of worker node group."
  type        = number
  default     = 2
}

# Variable Purpose: Controls "node_min_size" input behavior for this Terraform configuration interface.
variable "node_min_size" {
  description = "Minimum size of worker node group."
  type        = number
  default     = 1
}

# Variable Purpose: Controls "node_max_size" input behavior for this Terraform configuration interface.
variable "node_max_size" {
  description = "Maximum size of worker node group."
  type        = number
  default     = 4
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

# Variable Purpose: Controls "node_capacity_type" input behavior for this Terraform configuration interface.
variable "node_capacity_type" {
  description = "Capacity type for worker nodes (e.g., ON_DEMAND, SPOT)."
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

# Variable Purpose: Controls "node_force_update_version" input behavior for this Terraform configuration interface.
variable "node_force_update_version" {
  description = "Force node group version updates when pods cannot be drained gracefully."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "node_max_unavailable_percentage" input behavior for this Terraform configuration interface.
variable "node_max_unavailable_percentage" {
  description = "Maximum percentage of nodes unavailable during managed node group upgrades."
  type        = number
  default     = 33

  validation {
    condition     = var.node_max_unavailable_percentage >= 1 && var.node_max_unavailable_percentage <= 100
    error_message = "node_max_unavailable_percentage must be between 1 and 100."
  }
}

# Variable Purpose: Controls "addon_resolve_conflicts_on_create" input behavior for this Terraform configuration interface.
variable "addon_resolve_conflicts_on_create" {
  description = "Conflict resolution strategy for add-on creation."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.addon_resolve_conflicts_on_create)
    error_message = "addon_resolve_conflicts_on_create must be NONE or OVERWRITE."
  }
}

# Variable Purpose: Controls "addon_resolve_conflicts_on_update" input behavior for this Terraform configuration interface.
variable "addon_resolve_conflicts_on_update" {
  description = "Conflict resolution strategy for add-on updates."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE", "PRESERVE"], var.addon_resolve_conflicts_on_update)
    error_message = "addon_resolve_conflicts_on_update must be NONE, OVERWRITE, or PRESERVE."
  }
}

# Variable Purpose: Controls "coredns_addon_version" input behavior for this Terraform configuration interface.
variable "coredns_addon_version" {
  description = "Optional pinned version for the coredns addon."
  type        = string
  default     = null
}

# Variable Purpose: Controls "kube_proxy_addon_version" input behavior for this Terraform configuration interface.
variable "kube_proxy_addon_version" {
  description = "Optional pinned version for the kube-proxy addon."
  type        = string
  default     = null
}

# Variable Purpose: Controls "vpc_cni_addon_version" input behavior for this Terraform configuration interface.
variable "vpc_cni_addon_version" {
  description = "Optional pinned version for the vpc-cni addon."
  type        = string
  default     = null
}
