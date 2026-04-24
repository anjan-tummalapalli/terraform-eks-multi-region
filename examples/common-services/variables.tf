# -----------------------------------------------------------------------------
# File: examples/common-services/variables.tf
# Purpose:
#   Defines configurable inputs for example 'common-services'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy
# and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Provides configurable input "region" for this Terraform
# configuration.
variable "region" {
  type    = string
  default = "ap-south-1"
}

# Variable Purpose: Provides configurable input "vpc_id" for this Terraform
# configuration.
variable "vpc_id" {
  type = string
}

# Variable Purpose: Provides configurable input "private_subnet_ids" for this
# Terraform configuration.
variable "private_subnet_ids" {
  type = list(string)
}

# Variable Purpose: Provides configurable input "public_subnet_ids" for this
# Terraform configuration.
variable "public_subnet_ids" {
  type = list(string)
}

# Variable Purpose: Provides configurable input "db_username" for this
# Terraform configuration.
variable "db_username" {
  type = string
}

# Variable Purpose: Provides configurable input "db_password" for this
# Terraform configuration.
variable "db_password" {
  type      = string
  sensitive = true
}

# Variable Purpose: Provides configurable input "app_bucket_name" for this
# Terraform configuration.
variable "app_bucket_name" {
  type = string
}
