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

variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for naming resources."
  type        = string
  default     = "kms-demo"
}

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "admin_principal_arns" {
  description = "Optional IAM principal ARNs with full admin permissions on KMS key."
  type        = list(string)
  default     = []
}

variable "usage_principal_arns" {
  description = "Optional IAM principal ARNs allowed cryptographic key usage."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "kms"
  }
}
