# -----------------------------------------------------------------------------
# File: modules/s3/variables.tf
# Purpose:
#   Declares input interface for module 's3' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "bucket_name" input behavior for this Terraform configuration interface.
variable "bucket_name" {
  description = "Unique S3 bucket name."
  type        = string
}

# Variable Purpose: Controls "versioning_enabled" input behavior for this Terraform configuration interface.
variable "versioning_enabled" {
  description = "Enable object versioning."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "sse_algorithm" input behavior for this Terraform configuration interface.
variable "sse_algorithm" {
  description = "SSE algorithm for default encryption (AES256 or aws:kms)."
  type        = string
  default     = "AES256"
}

# Variable Purpose: Controls "kms_key_id" input behavior for this Terraform configuration interface.
variable "kms_key_id" {
  description = "Optional KMS key ID/ARN when sse_algorithm is aws:kms."
  type        = string
  default     = null
}

# Variable Purpose: Controls "force_destroy" input behavior for this Terraform configuration interface.
variable "force_destroy" {
  description = "Allow bucket destruction even when non-empty."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "enable_lifecycle_rule" input behavior for this Terraform configuration interface.
variable "enable_lifecycle_rule" {
  description = "Enable lifecycle expiration rule."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "enforce_ssl_requests" input behavior for this Terraform configuration interface.
variable "enforce_ssl_requests" {
  description = "Deny non-TLS requests to this S3 bucket."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "object_ownership" input behavior for this Terraform configuration interface.
variable "object_ownership" {
  description = "S3 object ownership setting."
  type        = string
  default     = "BucketOwnerEnforced"
}

# Variable Purpose: Controls "lifecycle_expiration_days" input behavior for this Terraform configuration interface.
variable "lifecycle_expiration_days" {
  description = "Expiration in days for lifecycle rule."
  type        = number
  default     = 30
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
