# -----------------------------------------------------------------------------
# File: modules/rds-mysql/variables.tf
# Purpose:
#   Declares input interface for module 'rds-mysql' (types, defaults,
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

# Variable Purpose: Name prefix for MySQL Relational Database Service (RDS)
# resources.
variable "name" {
  description = "Name prefix for MySQL RDS resources."
  type        = string
}

# Variable Purpose: Initial database name.
variable "db_name" {
  description = "Initial database name."
  type        = string
  default     = "appdb"
}

# Variable Purpose: Master username.
variable "username" {
  description = "Master username."
  type        = string
}

# Variable Purpose: Master password.
variable "password" {
  description = "Master password."
  type        = string
  sensitive   = true
}

# Variable Purpose: Relational Database Service (RDS) instance class.
variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t4g.micro"
}

# Variable Purpose: Allocated storage in GiB.
variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}

# Variable Purpose: MySQL engine version.
variable "engine_version" {
  description = "MySQL engine version."
  type        = string
  default     = "8.0"
}

# Variable Purpose: Storage type for the Database (DB) instance.
variable "storage_type" {
  description = "Storage type for the DB instance."
  type        = string
  default     = "gp3"
}

# Variable Purpose: Enable encryption at rest for the Database (DB) volume.
variable "storage_encrypted" {
  description = "Enable encryption at rest for the DB volume."
  type        = bool
  default     = true
}

# Variable Purpose: Optional Key Management Service (KMS) key ID/Amazon
# Resource Name (ARN) for storage encryption.
variable "kms_key_id" {
  description = "Optional KMS key ID/ARN for storage encryption."
  type        = string
  default     = null
}

# Variable Purpose: Virtual Private Cloud (VPC) ID for Database (DB) security
# group.
variable "vpc_id" {
  description = "VPC ID for DB security group."
  type        = string
}

# Variable Purpose: Private subnet IDs for Database (DB) subnet group.
variable "subnet_ids" {
  description = "Private subnet IDs for DB subnet group."
  type        = list(string)
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) blocks allowed to
# connect to Database (DB).
variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to DB."
  type        = list(string)
  default     = []
}

# Variable Purpose: Enable Multi-Availability Zone (AZ) deployment.
variable "multi_az" {
  description = "Enable Multi-AZ deployment."
  type        = bool
  default     = false
}

# Variable Purpose: Backup retention in days.
variable "backup_retention_period" {
  description = "Backup retention in days."
  type        = number
  default     = 3
}

# Variable Purpose: Apply Database (DB) changes immediately or during the
# maintenance window.
variable "apply_immediately" {
  description = "Apply DB changes immediately or during the maintenance window."
  type        = bool
  default     = false
}

# Variable Purpose: Automatically apply minor engine version upgrades.
variable "auto_minor_version_upgrade" {
  description = "Automatically apply minor engine version upgrades."
  type        = bool
  default     = true
}

# Variable Purpose: Allow major engine version upgrades when changing
# engine_version.
variable "allow_major_version_upgrade" {
  description = <<-EOT
    Allow major engine version upgrades when changing engine_version.
  EOT
  type        = bool
  default     = false
}

# Variable Purpose: Preferred maintenance window (UTC), for example
# Mon:00:00-Mon:03:00.
variable "maintenance_window" {
  description = <<-EOT
    Preferred maintenance window (UTC), for example Mon:00:00-Mon:03:00.
  EOT
  type        = string
  default     = null
}

# Variable Purpose: Preferred backup window (UTC), for example 03:00-04:00.
variable "backup_window" {
  description = "Preferred backup window (UTC), for example 03:00-04:00."
  type        = string
  default     = null
}

# Variable Purpose: Whether Database (DB) is publicly accessible.
variable "publicly_accessible" {
  description = "Whether DB is publicly accessible."
  type        = bool
  default     = false
}

# Variable Purpose: Whether to enable deletion protection.
variable "deletion_protection" {
  description = "Whether to enable deletion protection."
  type        = bool
  default     = false
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
