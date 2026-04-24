# -----------------------------------------------------------------------------
# File: modules/elasticache-redis/variables.tf
# Purpose:
#   Declares input interface for module 'elasticache-redis' (types, defaults,
# validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so
# callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Name prefix for Redis resources.
variable "name" {
  description = "Name prefix for Redis resources."
  type        = string
}

# Variable Purpose: Virtual Private Cloud (VPC) ID for Redis security group.
variable "vpc_id" {
  description = "VPC ID for Redis security group."
  type        = string
}

# Variable Purpose: Private subnet IDs for ElastiCache subnet group.
variable "subnet_ids" {
  description = "Private subnet IDs for ElastiCache subnet group."
  type        = list(string)
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) blocks allowed to
# access Redis.
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access Redis."
  type        = list(string)
  default     = []
}

# Variable Purpose: Cache node type.
variable "node_type" {
  description = "Cache node type."
  type        = string
  default     = "cache.t4g.micro"
}

# Variable Purpose: Redis engine version.
variable "engine_version" {
  description = "Redis engine version."
  type        = string
  default     = "7.1"
}

# Variable Purpose: Number of cache nodes.
variable "num_cache_nodes" {
  description = "Number of cache nodes."
  type        = number
  default     = 1
}

# Variable Purpose: Redis port.
variable "port" {
  description = "Redis port."
  type        = number
  default     = 6379
}

# Variable Purpose: ElastiCache parameter group name.
variable "parameter_group_name" {
  description = "ElastiCache parameter group name."
  type        = string
  default     = "default.redis7"
}

# Variable Purpose: Apply updates immediately.
variable "apply_immediately" {
  description = "Apply updates immediately."
  type        = bool
  default     = false
}

# Variable Purpose: Automatically apply minor engine version upgrades.
variable "auto_minor_version_upgrade" {
  description = "Automatically apply minor engine version upgrades."
  type        = bool
  default     = true
}

# Variable Purpose: Preferred maintenance window (UTC), for example
# sun:03:00-sun:04:00.
variable "maintenance_window" {
  description = <<-EOT
    Preferred maintenance window (UTC), for example sun:03:00-sun:04:00.
  EOT
  type        = string
  default     = null
}

# Variable Purpose: Number of days for automatic snapshot retention.
variable "snapshot_retention_limit" {
  description = "Number of days for automatic snapshot retention."
  type        = number
  default     = 1
}

# Variable Purpose: Preferred snapshot window (UTC), for example 04:00-05:00.
variable "snapshot_window" {
  description = "Preferred snapshot window (UTC), for example 04:00-05:00."
  type        = string
  default     = null
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
