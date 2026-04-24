# -----------------------------------------------------------------------------
# File: examples/cloudwatch-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'cloudwatch-basic'.
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

# Variable Purpose: Amazon Web Services (AWS) region for CloudWatch resources.
variable "region" {
  description = "AWS region for CloudWatch resources."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Prefix used for resource naming.
variable "name_prefix" {
  description = "Prefix used for resource naming."
  type        = string
  default     = "cw-demo"
}

# Variable Purpose: Optional email address for CloudWatch alarm notifications.
variable "alert_email" {
  description = "Optional email address for CloudWatch alarm notifications."
  type        = string
  default     = ""
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "cloudwatch"
  }
}
