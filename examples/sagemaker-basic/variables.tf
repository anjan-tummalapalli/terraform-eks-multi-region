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

variable "region" {
  description = "AWS region for SageMaker resources."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for SageMaker resources."
  type        = string
  default     = "sagemaker-demo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.60.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.60.1.0/24", "10.60.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
  default     = ["10.60.11.0/24", "10.60.12.0/24"]
}

variable "notebook_ingress_cidrs" {
  description = "CIDRs allowed to access notebook HTTPS endpoint."
  type        = list(string)
  default     = ["10.60.0.0/16"]
}

variable "instance_type" {
  description = "SageMaker notebook instance type (cost baseline uses ml.t3.medium)."
  type        = string
  default     = "ml.t3.medium"
}

variable "notebook_data_bucket_name" {
  description = "Globally unique S3 bucket name for notebook data."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "sagemaker"
  }
}
