# -----------------------------------------------------------------------------
# File: examples/sagemaker-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'sagemaker-basic'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "AWS region for SageMaker resources."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Controls "name_prefix" input behavior for this Terraform configuration interface.
variable "name_prefix" {
  description = "Prefix used for SageMaker resources."
  type        = string
  default     = "sagemaker-demo"
}

# Variable Purpose: Controls "vpc_cidr" input behavior for this Terraform configuration interface.
variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.60.0.0/16"
}

# Variable Purpose: Controls "public_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.60.1.0/24", "10.60.2.0/24"]
}

# Variable Purpose: Controls "private_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
  default     = ["10.60.11.0/24", "10.60.12.0/24"]
}

# Variable Purpose: Controls "notebook_ingress_cidrs" input behavior for this Terraform configuration interface.
variable "notebook_ingress_cidrs" {
  description = "CIDRs allowed to access notebook HTTPS endpoint."
  type        = list(string)
  default     = ["10.60.0.0/16"]
}

# Variable Purpose: Controls "instance_type" input behavior for this Terraform configuration interface.
variable "instance_type" {
  description = "SageMaker notebook instance type (cost baseline uses ml.t3.medium)."
  type        = string
  default     = "ml.t3.medium"
}

# Variable Purpose: Controls "notebook_data_bucket_name" input behavior for this Terraform configuration interface.
variable "notebook_data_bucket_name" {
  description = "Globally unique S3 bucket name for notebook data."
  type        = string
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "sagemaker"
  }
}
