# -----------------------------------------------------------------------------
# File: examples/kms-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'kms-basic'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Controls "name_prefix" input behavior for this Terraform configuration interface.
variable "name_prefix" {
  description = "Prefix used for naming resources."
  type        = string
  default     = "kms-demo"
}

# Variable Purpose: Controls "s3_bucket_name" input behavior for this Terraform configuration interface.
variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

# Variable Purpose: Controls "admin_principal_arns" input behavior for this Terraform configuration interface.
variable "admin_principal_arns" {
  description = "Optional IAM principal ARNs with full admin permissions on KMS key."
  type        = list(string)
  default     = []
}

# Variable Purpose: Controls "usage_principal_arns" input behavior for this Terraform configuration interface.
variable "usage_principal_arns" {
  description = "Optional IAM principal ARNs allowed cryptographic key usage."
  type        = list(string)
  default     = []
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "kms"
  }
}
