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

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Controls "name_prefix" input behavior for this Terraform configuration interface.
variable "name_prefix" {
  description = "Prefix used for resources."
  type        = string
  default     = "dbdemo"
}

# Variable Purpose: Controls "vpc_cidr" input behavior for this Terraform configuration interface.
variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.40.0.0/16"
}

# Variable Purpose: Controls "public_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.40.1.0/24", "10.40.2.0/24"]
}

# Variable Purpose: Controls "private_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = ["10.40.11.0/24", "10.40.12.0/24"]
}

# Variable Purpose: Controls "db_username" input behavior for this Terraform configuration interface.
variable "db_username" {
  description = "MySQL master username."
  type        = string
  default     = "admin"
}

# Variable Purpose: Controls "db_password" input behavior for this Terraform configuration interface.
variable "db_password" {
  description = "MySQL master password."
  type        = string
  sensitive   = true
}

# Variable Purpose: Controls "alert_email" input behavior for this Terraform configuration interface.
variable "alert_email" {
  description = "Optional email subscription for SNS alerts."
  type        = string
  default     = ""
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Stack     = "db-services"
  }
}
