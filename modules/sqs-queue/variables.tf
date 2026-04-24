# -----------------------------------------------------------------------------
# File: modules/sqs-queue/variables.tf
# Purpose:
#   Declares input interface for module 'sqs-queue' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "name" {
  description = "SQS queue name."
  type        = string
}

variable "fifo_queue" {
  description = "Whether queue is FIFO."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO queues."
  type        = bool
  default     = false
}

variable "delay_seconds" {
  description = "Delivery delay in seconds."
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "Max message size in bytes."
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "Message retention in seconds."
  type        = number
  default     = 345600
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
