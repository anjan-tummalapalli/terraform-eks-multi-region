# -----------------------------------------------------------------------------
# File: modules/rds-mysql/variables.tf
# Purpose:
#   Declares input interface for module 'rds-mysql' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "name" input behavior for this Terraform configuration interface.
variable "name" {
  description = "Name prefix for MySQL RDS resources."
  type        = string
}

# Variable Purpose: Controls "db_name" input behavior for this Terraform configuration interface.
variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "appdb"
}

# Variable Purpose: Controls "username" input behavior for this Terraform configuration interface.
variable "username" {
  description = "Master username."
  type        = string
}

# Variable Purpose: Controls "password" input behavior for this Terraform configuration interface.
variable "password" {
  description = "Master password."
  type        = string
  sensitive   = true
}

# Variable Purpose: Controls "instance_class" input behavior for this Terraform configuration interface.
variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

# Variable Purpose: Controls "allocated_storage" input behavior for this Terraform configuration interface.
variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}

# Variable Purpose: Controls "engine_version" input behavior for this Terraform configuration interface.
variable "engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

# Variable Purpose: Controls "storage_type" input behavior for this Terraform configuration interface.
variable "storage_type" {
  description = "Storage type for the DB instance."
  type        = string
  default     = "gp3"
}

# Variable Purpose: Controls "storage_encrypted" input behavior for this Terraform configuration interface.
variable "storage_encrypted" {
  description = "Enable encryption at rest for the DB volume."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "kms_key_id" input behavior for this Terraform configuration interface.
variable "kms_key_id" {
  description = "Optional KMS key ID/ARN for storage encryption."
  type        = string
  default     = null
}

# Variable Purpose: Controls "vpc_id" input behavior for this Terraform configuration interface.
variable "vpc_id" {
  description = "VPC ID for DB security group."
  type        = string
}

# Variable Purpose: Controls "subnet_ids" input behavior for this Terraform configuration interface.
variable "subnet_ids" {
  description = "Private subnet IDs for DB subnet group."
  type        = list(string)
}

# Variable Purpose: Controls "allowed_cidr_blocks" input behavior for this Terraform configuration interface.
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to DB."
  type        = list(string)
  default     = []
}

# Variable Purpose: Controls "multi_az" input behavior for this Terraform configuration interface.
variable "multi_az" {
  description = "Enable Multi-AZ deployment."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "backup_retention_period" input behavior for this Terraform configuration interface.
variable "backup_retention_period" {
  description = "Backup retention in days."
  type        = number
  default     = 3
}

# Variable Purpose: Controls "apply_immediately" input behavior for this Terraform configuration interface.
variable "apply_immediately" {
  description = "Apply DB changes immediately or during the maintenance window."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "auto_minor_version_upgrade" input behavior for this Terraform configuration interface.
variable "auto_minor_version_upgrade" {
  description = "Automatically apply minor engine version upgrades."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "allow_major_version_upgrade" input behavior for this Terraform configuration interface.
variable "allow_major_version_upgrade" {
  description = "Allow major engine version upgrades when changing engine_version."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "maintenance_window" input behavior for this Terraform configuration interface.
variable "maintenance_window" {
  description = "Preferred maintenance window (UTC), for example Mon:00:00-Mon:03:00."
  type        = string
  default     = null
}

# Variable Purpose: Controls "backup_window" input behavior for this Terraform configuration interface.
variable "backup_window" {
  description = "Preferred backup window (UTC), for example 03:00-04:00."
  type        = string
  default     = null
}

# Variable Purpose: Controls "publicly_accessible" input behavior for this Terraform configuration interface.
variable "publicly_accessible" {
  description = "Whether DB is publicly accessible."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "deletion_protection" input behavior for this Terraform configuration interface.
variable "deletion_protection" {
  description = "Whether to enable deletion protection."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
