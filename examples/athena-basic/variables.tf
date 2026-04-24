# -----------------------------------------------------------------------------
# File: examples/athena-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'athena-basic'.
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

# Variable Purpose: Amazon Web Services (AWS) region for Athena resources.
variable "region" {
  description = "AWS region for Athena resources."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Prefix used for Athena resources.
variable "name_prefix" {
  description = "Prefix used for Athena resources."
  type        = string
  default     = "athena-demo"
}

# Variable Purpose: Globally unique Simple Storage Service (S3) bucket name for
# Athena query results.
variable "athena_results_bucket_name" {
  description = "Globally unique S3 bucket name for Athena query results."
  type        = string
}

# Variable Purpose: Athena database name to create.
variable "database_name" {
  description = "Athena database name to create."
  type        = string
  default     = "analytics_db"
}

# Variable Purpose: Per-query scan cap in bytes to keep Athena costs
# predictable.
variable "bytes_scanned_cutoff_per_query" {
  description = "Per-query scan cap in bytes to keep Athena costs predictable."
  type        = number
  default     = 1073741824
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "athena"
  }
}
