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
  default     = true
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS control plane."
  type        = string
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

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
