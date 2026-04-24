# -----------------------------------------------------------------------------
# File: modules/eks/variables.tf
# Purpose:
#   Declares input interface for module 'eks' (types, defaults, validation).
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

# Variable Purpose: Elastic Kubernetes Service (EKS) upgrade support type for
# the control plane.
variable "cluster_upgrade_support_type" {
  description = "EKS upgrade support type for the control plane."
  type        = string
  default     = "STANDARD"

  validation {
    condition = (
      contains(["STANDARD", "EXTENDED"], var.cluster_upgrade_support_type)
    )
    error_message = "cluster_upgrade_support_type must be STANDARD or EXTENDED."
  }
}

# Variable Purpose: Enable private access to the Kubernetes Application
# Programming Interface (API) server endpoint.
variable "cluster_endpoint_private_access" {
  description = "Enable private access to the Kubernetes API server endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Enable public access to the Kubernetes Application
# Programming Interface (API) server endpoint.
variable "cluster_endpoint_public_access" {
  description = "Enable public access to the Kubernetes API server endpoint."
  type        = bool
  default     = true
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) blocks that can
# access the public Elastic Kubernetes Service (EKS) endpoint.
variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks that can access the public EKS endpoint."
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

# Variable Purpose: Virtual Private Cloud (VPC) ID for cluster networking.
variable "vpc_id" {
  description = "VPC ID for cluster networking."
  type        = string
}

# Variable Purpose: Private subnet IDs for worker nodes.
variable "private_subnet_ids" {
  description = "Private subnet IDs for worker nodes."
  type        = list(string)
}

# Variable Purpose: Identity and Access Management (IAM) role Amazon Resource
# Name (ARN) for Elastic Kubernetes Service (EKS) control plane.
variable "cluster_role_arn" {
  description = "IAM role ARN for EKS control plane."
  type        = string
}

# Variable Purpose: Identity and Access Management (IAM) role Amazon Resource
# Name (ARN) for Elastic Kubernetes Service (EKS) managed node group.
variable "node_role_arn" {
  description = "IAM role ARN for EKS managed node group."
  type        = string
}

# Variable Purpose: Instance types for worker nodes.
variable "node_instance_types" {
  description = "Instance types for worker nodes."
  type        = list(string)
  default     = ["t3.small"]
}

# Variable Purpose: Desired size of worker node group.
variable "node_desired_size" {
  description = "Desired size of worker node group."
  type        = number
  default     = 2
}

# Variable Purpose: Minimum size of worker node group.
variable "node_min_size" {
  description = "Minimum size of worker node group."
  type        = number
  default     = 1
}

# Variable Purpose: Maximum size of worker node group.
variable "node_max_size" {
  description = "Maximum size of worker node group."
  type        = number
  default     = 4
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

# Variable Purpose: Capacity type for worker nodes (e.g., ON_DEMAND, SPOT).
variable "node_capacity_type" {
  description = "Capacity type for worker nodes (e.g., ON_DEMAND, SPOT)."
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

# Variable Purpose: Force node group version updates when pods cannot be
# drained gracefully.
variable "node_force_update_version" {
  description = <<-EOT
    Force node group version updates when pods cannot be drained gracefully.
  EOT
  type        = bool
  default     = true
}

# Variable Purpose: Maximum percentage of nodes unavailable during managed node
# group upgrades.
variable "node_max_unavailable_percentage" {
  description = <<-EOT
    Maximum percentage of nodes unavailable during managed node group upgrades.
  EOT
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

# Variable Purpose: Conflict resolution strategy for add-on creation.
variable "addon_resolve_conflicts_on_create" {
  description = "Conflict resolution strategy for add-on creation."
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

# Variable Purpose: Conflict resolution strategy for add-on updates.
variable "addon_resolve_conflicts_on_update" {
  description = "Conflict resolution strategy for add-on updates."
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

# Variable Purpose: Optional pinned version for the coredns addon.
variable "coredns_addon_version" {
  description = "Optional pinned version for the coredns addon."
  type        = string
  default     = null
}

# Variable Purpose: Optional pinned version for the kube-proxy addon.
variable "kube_proxy_addon_version" {
  description = "Optional pinned version for the kube-proxy addon."
  type        = string
  default     = null
}

# Variable Purpose: Optional pinned version for the vpc-cni addon.
variable "vpc_cni_addon_version" {
  description = "Optional pinned version for the vpc-cni addon."
  type        = string
  default     = null
}
