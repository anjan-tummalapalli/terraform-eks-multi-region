variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS control plane."
  type        = string
}

variable "cluster_upgrade_support_type" {
  description = "EKS upgrade support type for the control plane."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXTENDED"], var.cluster_upgrade_support_type)
    error_message = "cluster_upgrade_support_type must be STANDARD or EXTENDED."
  }
}

variable "vpc_id" {
  description = "VPC ID for cluster networking."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for worker nodes."
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS control plane."
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS managed node group."
  type        = string
}

variable "node_instance_types" {
  description = "Instance types for worker nodes."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired size of worker node group."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum size of worker node group."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum size of worker node group."
  type        = number
  default     = 4
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

variable "node_capacity_type" {
  description = "Capacity type for worker nodes (e.g., ON_DEMAND, SPOT)."
  type        = string
  default     = "SPOT"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "node_force_update_version" {
  description = "Force node group version updates when pods cannot be drained gracefully."
  type        = bool
  default     = true
}

variable "node_max_unavailable_percentage" {
  description = "Maximum percentage of nodes unavailable during managed node group upgrades."
  type        = number
  default     = 33

  validation {
    condition     = var.node_max_unavailable_percentage >= 1 && var.node_max_unavailable_percentage <= 100
    error_message = "node_max_unavailable_percentage must be between 1 and 100."
  }
}

variable "addon_resolve_conflicts_on_create" {
  description = "Conflict resolution strategy for add-on creation."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE"], var.addon_resolve_conflicts_on_create)
    error_message = "addon_resolve_conflicts_on_create must be NONE or OVERWRITE."
  }
}

variable "addon_resolve_conflicts_on_update" {
  description = "Conflict resolution strategy for add-on updates."
  type        = string
  default     = "OVERWRITE"

  validation {
    condition     = contains(["NONE", "OVERWRITE", "PRESERVE"], var.addon_resolve_conflicts_on_update)
    error_message = "addon_resolve_conflicts_on_update must be NONE, OVERWRITE, or PRESERVE."
  }
}

variable "coredns_addon_version" {
  description = "Optional pinned version for the coredns addon."
  type        = string
  default     = null
}

variable "kube_proxy_addon_version" {
  description = "Optional pinned version for the kube-proxy addon."
  type        = string
  default     = null
}

variable "vpc_cni_addon_version" {
  description = "Optional pinned version for the vpc-cni addon."
  type        = string
  default     = null
}
