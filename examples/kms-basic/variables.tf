# -----------------------------------------------------------------------------
# File: examples/kms-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'kms-basic'.
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

# Variable Purpose: Amazon Web Services (AWS) region.
variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Prefix used for naming resources.
variable "name_prefix" {
  description = "Prefix used for naming resources."
  type        = string
  default     = "kms-demo"
}

# Variable Purpose: Globally unique Simple Storage Service (S3) bucket name.
variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

# Variable Purpose: Optional Identity and Access Management (IAM) principal
# Amazon Resource Names (ARNs) with full admin permissions on Key Management
# Service (KMS) key.
variable "admin_principal_arns" {
  description = <<-EOT
    Optional IAM principal ARNs with full admin permissions on KMS key.
  EOT
  type        = list(string)
  default     = []
}

# Variable Purpose: Optional Identity and Access Management (IAM) principal
# Amazon Resource Names (ARNs) allowed cryptographic key usage.
variable "usage_principal_arns" {
  description = "Optional IAM principal ARNs allowed cryptographic key usage."
  type        = list(string)
  default     = []
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "kms"
  }
}
