# -----------------------------------------------------------------------------
# File: examples/common-services/variables.tf
# Purpose:
#   Defines configurable inputs for example 'common-services'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  type    = string
  default = "ap-south-1"
}

# Variable Purpose: Controls "vpc_id" input behavior for this Terraform configuration interface.
variable "vpc_id" {
  type = string
}

# Variable Purpose: Controls "private_subnet_ids" input behavior for this Terraform configuration interface.
variable "private_subnet_ids" {
  type = list(string)
}

# Variable Purpose: Controls "public_subnet_ids" input behavior for this Terraform configuration interface.
variable "public_subnet_ids" {
  type = list(string)
}

# Variable Purpose: Controls "db_username" input behavior for this Terraform configuration interface.
variable "db_username" {
  type = string
}

# Variable Purpose: Controls "db_password" input behavior for this Terraform configuration interface.
variable "db_password" {
  type      = string
  sensitive = true
}

# Variable Purpose: Controls "app_bucket_name" input behavior for this Terraform configuration interface.
variable "app_bucket_name" {
  type = string
}
