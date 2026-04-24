# -----------------------------------------------------------------------------
# File: modules/sns-topic/variables.tf
# Purpose:
#   Declares input interface for module 'sns-topic' (types, defaults, validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Simple Notification Service (SNS) topic name.
variable "name" {
  description = "SNS topic name."
  type        = string
}

# Variable Purpose: Whether Simple Notification Service (SNS) topic is First In, First Out (FIFO).
variable "fifo_topic" {
  description = "Whether SNS topic is FIFO."
  type        = bool
  default     = false
}

# Variable Purpose: Enable content-based deduplication for First In, First Out (FIFO) topic.
variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topic."
  type        = bool
  default     = false
}

# Variable Purpose: Optional Key Management Service (KMS) key ID for topic encryption.
variable "kms_master_key_id" {
  description = "Optional KMS key ID for topic encryption."
  type        = string
  default     = null
}

# Variable Purpose: Topic subscriptions.
variable "subscriptions" {
  description = "Topic subscriptions."
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
