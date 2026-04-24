# -----------------------------------------------------------------------------
# File: examples/db-services/variables.tf
# Purpose:
#   Defines configurable inputs for example 'db-services'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for resources."
  type        = string
  default     = "dbdemo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.40.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.40.1.0/24", "10.40.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = ["10.40.11.0/24", "10.40.12.0/24"]
}

variable "db_username" {
  description = "MySQL master username."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "MySQL master password."
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Optional email subscription for SNS alerts."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Stack     = "db-services"
  }
}
