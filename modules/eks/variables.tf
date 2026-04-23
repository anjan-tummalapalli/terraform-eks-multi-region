variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS control plane."
  type        = string
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
}
