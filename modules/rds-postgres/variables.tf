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
  default     = 7
}

variable "publicly_accessible" {
  description = "Whether DB is publicly accessible."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
