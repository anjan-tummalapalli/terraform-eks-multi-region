# -----------------------------------------------------------------------------
# File: examples/sagemaker-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'sagemaker-basic'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy
# and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Amazon Web Services (AWS) region for SageMaker resources.
variable "region" {
  description = "AWS region for SageMaker resources."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Prefix used for SageMaker resources.
variable "name_prefix" {
  description = "Prefix used for SageMaker resources."
  type        = string
  default     = "sagemaker-demo"
}

# Variable Purpose: Virtual Private Cloud (VPC) Classless Inter-Domain Routing
# (CIDR) block.
variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.60.0.0/16"
}

# Variable Purpose: Public subnet Classless Inter-Domain Routing (CIDR) blocks.
variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.60.1.0/24", "10.60.2.0/24"]
}

# Variable Purpose: Private subnet Classless Inter-Domain Routing (CIDR) blocks.
variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
  default     = ["10.60.11.0/24", "10.60.12.0/24"]
}

# Variable Purpose: Classless Inter-Domain Routing blocks (CIDRs) allowed to
# access notebook HTTPS endpoint.
variable "notebook_ingress_cidrs" {
  description = "CIDRs allowed to access notebook HTTPS endpoint."
  type        = list(string)
  default     = ["10.60.0.0/16"]
}

# Variable Purpose: SageMaker notebook instance type (cost baseline uses
# ml.t3.medium).
variable "instance_type" {
  description = <<-EOT
    SageMaker notebook instance type (cost baseline uses ml.t3.medium).
  EOT
  type        = string
  default     = "ml.t3.medium"
}

# Variable Purpose: Globally unique Simple Storage Service (S3) bucket name for
# notebook data.
variable "notebook_data_bucket_name" {
  description = "Globally unique S3 bucket name for notebook data."
  type        = string
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "sagemaker"
  }
}
