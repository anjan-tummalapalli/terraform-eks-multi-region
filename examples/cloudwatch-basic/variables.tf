# -----------------------------------------------------------------------------
# File: examples/cloudwatch-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'cloudwatch-basic'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "AWS region for CloudWatch resources."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Controls "name_prefix" input behavior for this Terraform configuration interface.
variable "name_prefix" {
  description = "Prefix used for resource naming."
  type        = string
  default     = "cw-demo"
}

# Variable Purpose: Controls "alert_email" input behavior for this Terraform configuration interface.
variable "alert_email" {
  description = "Optional email address for CloudWatch alarm notifications."
  type        = string
  default     = ""
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "cloudwatch"
  }
}
