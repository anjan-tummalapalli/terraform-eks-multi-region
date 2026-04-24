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

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "app_bucket_name" {
  type = string
}
