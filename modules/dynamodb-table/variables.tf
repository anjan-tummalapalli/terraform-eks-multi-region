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

# Variable Purpose: Controls "table_name" input behavior for this Terraform configuration interface.
variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
}

# Variable Purpose: Controls "hash_key" input behavior for this Terraform configuration interface.
variable "hash_key" {
  description = "Hash (partition) key name."
  type        = string
}

# Variable Purpose: Controls "hash_key_type" input behavior for this Terraform configuration interface.
variable "hash_key_type" {
  description = "Hash key type: S, N, or B."
  type        = string
  default     = "S"

  validation {
    condition     = contains(["S", "N", "B"], var.hash_key_type)
    error_message = "hash_key_type must be one of S, N, B."
  }
}

# Variable Purpose: Controls "range_key" input behavior for this Terraform configuration interface.
variable "range_key" {
  description = "Optional range (sort) key name."
  type        = string
  default     = null
}

# Variable Purpose: Controls "range_key_type" input behavior for this Terraform configuration interface.
variable "range_key_type" {
  description = "Range key type: S, N, or B."
  type        = string
  default     = "S"

  validation {
    condition     = contains(["S", "N", "B"], var.range_key_type)
    error_message = "range_key_type must be one of S, N, B."
  }
}

# Variable Purpose: Controls "billing_mode" input behavior for this Terraform configuration interface.
variable "billing_mode" {
  description = "DynamoDB billing mode: PAY_PER_REQUEST or PROVISIONED."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }
}

# Variable Purpose: Controls "read_capacity" input behavior for this Terraform configuration interface.
variable "read_capacity" {
  description = "Read capacity units for PROVISIONED mode."
  type        = number
  default     = 5
}

# Variable Purpose: Controls "write_capacity" input behavior for this Terraform configuration interface.
variable "write_capacity" {
  description = "Write capacity units for PROVISIONED mode."
  type        = number
  default     = 5
}

# Variable Purpose: Controls "ttl_enabled" input behavior for this Terraform configuration interface.
variable "ttl_enabled" {
  description = "Enable TTL on the table."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "ttl_attribute_name" input behavior for this Terraform configuration interface.
variable "ttl_attribute_name" {
  description = "TTL attribute name used when ttl_enabled is true."
  type        = string
  default     = "expires_at"
}

# Variable Purpose: Controls "point_in_time_recovery_enabled" input behavior for this Terraform configuration interface.
variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
