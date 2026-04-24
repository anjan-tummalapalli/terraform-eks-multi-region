# -----------------------------------------------------------------------------
# File: examples/athena-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'athena-basic'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "AWS region for Athena resources."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Controls "name_prefix" input behavior for this Terraform configuration interface.
variable "name_prefix" {
  description = "Prefix used for Athena resources."
  type        = string
  default     = "athena-demo"
}

# Variable Purpose: Controls "athena_results_bucket_name" input behavior for this Terraform configuration interface.
variable "athena_results_bucket_name" {
  description = "Globally unique S3 bucket name for Athena query results."
  type        = string
}

# Variable Purpose: Controls "database_name" input behavior for this Terraform configuration interface.
variable "database_name" {
  description = "Athena database name to create."
  type        = string
  default     = "analytics_db"
}

# Variable Purpose: Controls "bytes_scanned_cutoff_per_query" input behavior for this Terraform configuration interface.
variable "bytes_scanned_cutoff_per_query" {
  description = "Per-query scan cap in bytes to keep Athena costs predictable."
  type        = number
  default     = 1073741824
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "athena"
  }
}
