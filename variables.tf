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

variable "node_instance_types" {
  description = "EKS managed node group instance types."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "Node group capacity type: SPOT (cost optimized) or ON_DEMAND."
  type        = string
  default     = "SPOT"
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
