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

# Variable Purpose: Amazon Web Services (AWS) region.
variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Prefix used for resources.
variable "name_prefix" {
  description = "Prefix used for resources."
  type        = string
  default     = "dbdemo"
}

# Variable Purpose: Virtual Private Cloud (VPC) Classless Inter-Domain Routing (CIDR) block.
variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.40.0.0/16"
}

# Variable Purpose: Public subnet Classless Inter-Domain Routing blocks (CIDRs).
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.40.1.0/24", "10.40.2.0/24"]
}

# Variable Purpose: Private subnet Classless Inter-Domain Routing blocks (CIDRs).
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = ["10.40.11.0/24", "10.40.12.0/24"]
}

# Variable Purpose: MySQL master username.
variable "db_username" {
  description = "MySQL master username."
  type        = string
  default     = "admin"
}

# Variable Purpose: MySQL master password.
variable "db_password" {
  description = "MySQL master password."
  type        = string
  sensitive   = true
}

# Variable Purpose: Optional email subscription for Simple Notification Service (SNS) alerts.
variable "alert_email" {
  description = "Optional email subscription for SNS alerts."
  type        = string
  default     = ""
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Stack     = "db-services"
  }
}
