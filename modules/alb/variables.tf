# -----------------------------------------------------------------------------
# File: modules/alb/variables.tf
# Purpose:
#   Declares input interface for module 'alb' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name prefix for ALB resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB and target group are created."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ALB."
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "internal" {
  description = "Whether ALB is internal."
  type        = bool
  default     = false
}

variable "target_port" {
  description = "Target group port."
  type        = number
  default     = 80
}

variable "listener_port" {
  description = "ALB listener port."
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for target group."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
