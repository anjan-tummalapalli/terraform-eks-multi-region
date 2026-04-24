# -----------------------------------------------------------------------------
# File: modules/alb/variables.tf
# Purpose:
#   Declares input interface for module 'alb' (types, defaults, validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Name prefix for Application Load Balancer (ALB) resources.
variable "name" {
  description = "Name prefix for ALB resources."
  type        = string
}

# Variable Purpose: Virtual Private Cloud (VPC) ID where Application Load Balancer (ALB) and target group are created.
variable "vpc_id" {
  description = "VPC ID where ALB and target group are created."
  type        = string
}

# Variable Purpose: Subnet IDs for Application Load Balancer (ALB).
variable "subnet_ids" {
  description = "Subnet IDs for ALB."
  type        = list(string)
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) blocks allowed to access Application Load Balancer (ALB).
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Variable Purpose: Whether Application Load Balancer (ALB) is internal.
variable "internal" {
  description = "Whether ALB is internal."
  type        = bool
  default     = false
}

# Variable Purpose: Target group port.
variable "target_port" {
  description = "Target group port."
  type        = number
  default     = 80
}

# Variable Purpose: Application Load Balancer (ALB) listener port.
variable "listener_port" {
  description = "ALB listener port."
  type        = number
  default     = 80
}

# Variable Purpose: Health check path for target group.
variable "health_check_path" {
  description = "Health check path for target group."
  type        = string
  default     = "/"
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
