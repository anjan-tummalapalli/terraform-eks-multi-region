# -----------------------------------------------------------------------------
# File: modules/athena/variables.tf
# Purpose:
#   Declares input interface for module 'athena' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "name" {
  description = "Athena workgroup name."
  type        = string
}

variable "description" {
  description = "Athena workgroup description."
  type        = string
  default     = "Athena workgroup managed by Terraform"
}

variable "state" {
  description = "State for Athena workgroup (ENABLED or DISABLED)."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "state must be ENABLED or DISABLED."
  }
}

variable "force_destroy" {
  description = "Allow workgroup deletion even if named queries are associated."
  type        = bool
  default     = false
}

variable "result_output_location" {
  description = "S3 location for Athena query results in the form s3://bucket/prefix/."
  type        = string

  validation {
    condition     = can(regex("^s3://", var.result_output_location))
    error_message = "result_output_location must start with s3://"
  }
}

variable "result_encryption_option" {
  description = "Encryption for query results: SSE_S3, SSE_KMS, or CSE_KMS."
  type        = string
  default     = "SSE_S3"

  validation {
    condition     = contains(["SSE_S3", "SSE_KMS", "CSE_KMS"], var.result_encryption_option)
    error_message = "result_encryption_option must be SSE_S3, SSE_KMS, or CSE_KMS."
  }
}

variable "result_kms_key_arn" {
  description = "KMS key ARN when result_encryption_option is SSE_KMS or CSE_KMS."
  type        = string
  default     = null

  validation {
    condition = (
      var.result_encryption_option == "SSE_S3" && var.result_kms_key_arn == null
      ) || (
      contains(["SSE_KMS", "CSE_KMS"], var.result_encryption_option) && var.result_kms_key_arn != null
    )
    error_message = "Set result_kms_key_arn when using SSE_KMS or CSE_KMS; keep it null for SSE_S3."
  }
}

variable "expected_bucket_owner" {
  description = "Optional AWS account ID expected to own the Athena result bucket."
  type        = string
  default     = null
}

variable "enforce_workgroup_configuration" {
  description = "Enforce workgroup configuration so client-side settings cannot override controls."
  type        = bool
  default     = true
}

variable "publish_cloudwatch_metrics_enabled" {
  description = "Publish query metrics to CloudWatch."
  type        = bool
  default     = true
}

variable "requester_pays_enabled" {
  description = "Enable requester pays for Athena queries."
  type        = bool
  default     = false
}

variable "bytes_scanned_cutoff_per_query" {
  description = "Per-query data scan cutoff in bytes to cap costs. Null disables cutoff."
  type        = number
  default     = 1073741824

  validation {
    condition     = var.bytes_scanned_cutoff_per_query == null || var.bytes_scanned_cutoff_per_query > 0
    error_message = "bytes_scanned_cutoff_per_query must be null or greater than zero."
  }
}

variable "engine_version" {
  description = "Optional Athena engine version (for example Athena engine version 3)."
  type        = string
  default     = null
}

variable "create_database" {
  description = "Whether to create an Athena database."
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Athena database name when create_database is true."
  type        = string
  default     = null

  validation {
    condition = var.create_database ? (
      var.database_name != null && trim(var.database_name) != ""
    ) : true
    error_message = "database_name must be set when create_database is true."
  }
}

variable "database_comment" {
  description = "Optional Athena database comment."
  type        = string
  default     = null
}

variable "database_bucket" {
  description = "Optional S3 bucket for Athena database metadata."
  type        = string
  default     = null
}

variable "database_force_destroy" {
  description = "Allow deleting database even if it contains tables."
  type        = bool
  default     = false
}

variable "database_encryption_option" {
  description = "Optional encryption for database metadata (SSE_S3 or SSE_KMS)."
  type        = string
  default     = null

  validation {
    condition = (
      var.database_encryption_option == null ||
      contains(["SSE_S3", "SSE_KMS"], var.database_encryption_option)
    )
    error_message = "database_encryption_option must be null, SSE_S3, or SSE_KMS."
  }
}

variable "database_kms_key_arn" {
  description = "Optional KMS key ARN for database encryption when database_encryption_option is SSE_KMS."
  type        = string
  default     = null

  validation {
    condition = (
      var.database_encryption_option == null && var.database_kms_key_arn == null
      ) || (
      var.database_encryption_option == "SSE_S3" && var.database_kms_key_arn == null
      ) || (
      var.database_encryption_option == "SSE_KMS" && var.database_kms_key_arn != null
    )
    error_message = "database_kms_key_arn must be set only when database_encryption_option is SSE_KMS."
  }
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
