# -----------------------------------------------------------------------------
# File: modules/sns-topic/variables.tf
# Purpose:
#   Declares input interface for module 'sns-topic' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "name" input behavior for this Terraform configuration interface.
variable "name" {
  description = "SNS topic name."
  type        = string
}

# Variable Purpose: Controls "fifo_topic" input behavior for this Terraform configuration interface.
variable "fifo_topic" {
  description = "Whether SNS topic is FIFO."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "content_based_deduplication" input behavior for this Terraform configuration interface.
variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topic."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "kms_master_key_id" input behavior for this Terraform configuration interface.
variable "kms_master_key_id" {
  description = "Optional KMS key ID for topic encryption."
  type        = string
  default     = null
}

# Variable Purpose: Controls "subscriptions" input behavior for this Terraform configuration interface.
variable "subscriptions" {
  description = "Topic subscriptions."
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
