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

# Variable Purpose: Controls "name" input behavior for this Terraform configuration interface.
variable "name" {
  description = "SQS queue name."
  type        = string
}

# Variable Purpose: Controls "fifo_queue" input behavior for this Terraform configuration interface.
variable "fifo_queue" {
  description = "Whether queue is FIFO."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "content_based_deduplication" input behavior for this Terraform configuration interface.
variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO queues."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "delay_seconds" input behavior for this Terraform configuration interface.
variable "delay_seconds" {
  description = "Delivery delay in seconds."
  type        = number
  default     = 0
}

# Variable Purpose: Controls "max_message_size" input behavior for this Terraform configuration interface.
variable "max_message_size" {
  description = "Max message size in bytes."
  type        = number
  default     = 262144
}

# Variable Purpose: Controls "message_retention_seconds" input behavior for this Terraform configuration interface.
variable "message_retention_seconds" {
  description = "Message retention in seconds."
  type        = number
  default     = 345600
}

# Variable Purpose: Controls "visibility_timeout_seconds" input behavior for this Terraform configuration interface.
variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds."
  type        = number
  default     = 30
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
