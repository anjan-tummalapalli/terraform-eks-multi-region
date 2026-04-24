# -----------------------------------------------------------------------------
# File: modules/rds-postgres/variables.tf
# Purpose:
#   Declares input interface for module 'rds-postgres' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "name" {
  description = "Name prefix for RDS resources."
  type        = string
}

variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Master username."
  type        = string
}

variable "password" {
  description = "Master password."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}

variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
  default     = "16.2"
}

variable "storage_type" {
  description = "Storage type for the DB instance."
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Enable encryption at rest for the DB volume."
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Optional KMS key ID/ARN for storage encryption."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID for DB security group."
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for DB subnet group."
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to DB."
  type        = list(string)
  default     = []
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention in days."
  type        = number
  default     = 3
}

variable "apply_immediately" {
  description = "Apply DB changes immediately or during the maintenance window."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Automatically apply minor engine version upgrades."
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major engine version upgrades when changing engine_version."
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "Preferred maintenance window (UTC), for example Mon:00:00-Mon:03:00."
  type        = string
  default     = null
}

variable "backup_window" {
  description = "Preferred backup window (UTC), for example 03:00-04:00."
  type        = string
  default     = null
}

variable "publicly_accessible" {
  description = "Whether DB is publicly accessible."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
