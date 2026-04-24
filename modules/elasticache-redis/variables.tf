# -----------------------------------------------------------------------------
# File: modules/elasticache-redis/variables.tf
# Purpose:
#   Declares input interface for module 'elasticache-redis' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "name" input behavior for this Terraform configuration interface.
variable "name" {
  description = "Name prefix for Redis resources."
  type        = string
}

# Variable Purpose: Controls "vpc_id" input behavior for this Terraform configuration interface.
variable "vpc_id" {
  description = "VPC ID for Redis security group."
  type        = string
}

# Variable Purpose: Controls "subnet_ids" input behavior for this Terraform configuration interface.
variable "subnet_ids" {
  description = "Private subnet IDs for ElastiCache subnet group."
  type        = list(string)
}

# Variable Purpose: Controls "allowed_cidr_blocks" input behavior for this Terraform configuration interface.
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access Redis."
  type        = list(string)
  default     = []
}

# Variable Purpose: Controls "node_type" input behavior for this Terraform configuration interface.
variable "node_type" {
  description = "Cache node type."
  type        = string
  default     = "cache.t4g.micro"
}

# Variable Purpose: Controls "engine_version" input behavior for this Terraform configuration interface.
variable "engine_version" {
  description = "Redis engine version."
  type        = string
  default     = "7.1"
}

# Variable Purpose: Controls "num_cache_nodes" input behavior for this Terraform configuration interface.
variable "num_cache_nodes" {
  description = "Number of cache nodes."
  type        = number
  default     = 1
}

# Variable Purpose: Controls "port" input behavior for this Terraform configuration interface.
variable "port" {
  description = "Redis port."
  type        = number
  default     = 6379
}

# Variable Purpose: Controls "parameter_group_name" input behavior for this Terraform configuration interface.
variable "parameter_group_name" {
  description = "ElastiCache parameter group name."
  type        = string
  default     = "default.redis7"
}

# Variable Purpose: Controls "apply_immediately" input behavior for this Terraform configuration interface.
variable "apply_immediately" {
  description = "Apply updates immediately."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "auto_minor_version_upgrade" input behavior for this Terraform configuration interface.
variable "auto_minor_version_upgrade" {
  description = "Automatically apply minor engine version upgrades."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "maintenance_window" input behavior for this Terraform configuration interface.
variable "maintenance_window" {
  description = "Preferred maintenance window (UTC), for example sun:03:00-sun:04:00."
  type        = string
  default     = null
}

# Variable Purpose: Controls "snapshot_retention_limit" input behavior for this Terraform configuration interface.
variable "snapshot_retention_limit" {
  description = "Number of days for automatic snapshot retention."
  type        = number
  default     = 1
}

# Variable Purpose: Controls "snapshot_window" input behavior for this Terraform configuration interface.
variable "snapshot_window" {
  description = "Preferred snapshot window (UTC), for example 04:00-05:00."
  type        = string
  default     = null
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
