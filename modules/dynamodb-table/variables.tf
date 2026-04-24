# -----------------------------------------------------------------------------
# File: modules/dynamodb-table/variables.tf
# Purpose:
#   Declares input interface for module 'dynamodb-table' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "hash_key" {
  description = "Hash (partition) key name."
  type        = string
}

variable "hash_key_type" {
  description = "Hash key type: S, N, or B."
  type        = string
  default     = "S"

  validation {
    condition     = contains(["S", "N", "B"], var.hash_key_type)
    error_message = "hash_key_type must be one of S, N, B."
  }
}

variable "range_key" {
  description = "Optional range (sort) key name."
  type        = string
  default     = null
}

variable "range_key_type" {
  description = "Range key type: S, N, or B."
  type        = string
  default     = "S"

  validation {
    condition     = contains(["S", "N", "B"], var.range_key_type)
    error_message = "range_key_type must be one of S, N, B."
  }
}

variable "billing_mode" {
  description = "DynamoDB billing mode: PAY_PER_REQUEST or PROVISIONED."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "read_capacity" {
  description = "Read capacity units for PROVISIONED mode."
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units for PROVISIONED mode."
  type        = number
  default     = 5
}

variable "ttl_enabled" {
  description = "Enable TTL on the table."
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "TTL attribute name used when ttl_enabled is true."
  type        = string
  default     = "expires_at"
}

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
