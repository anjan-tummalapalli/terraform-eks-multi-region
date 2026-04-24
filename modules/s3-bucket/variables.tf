# -----------------------------------------------------------------------------
# File: modules/s3-bucket/variables.tf
# Purpose:
#   Declares input interface for module 's3-bucket' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "bucket_name" {
  description = "Unique S3 bucket name."
  type        = string
}

variable "versioning_enabled" {
  description = "Enable object versioning."
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "SSE algorithm for default encryption (AES256 or aws:kms)."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "aws:kms"], var.sse_algorithm)
    error_message = "sse_algorithm must be AES256 or aws:kms."
  }
}

variable "kms_key_id" {
  description = "Optional KMS key ID/ARN when sse_algorithm is aws:kms."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Allow bucket destruction even when non-empty."
  type        = bool
  default     = false
}

variable "enable_lifecycle_rule" {
  description = "Enable lifecycle expiration rule."
  type        = bool
  default     = false
}

variable "enforce_ssl_requests" {
  description = "Deny non-TLS requests to this S3 bucket."
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "S3 object ownership setting."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter."
  }
}

variable "lifecycle_expiration_days" {
  description = "Expiration in days for lifecycle rule."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
