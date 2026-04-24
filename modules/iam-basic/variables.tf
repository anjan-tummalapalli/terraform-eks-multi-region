# -----------------------------------------------------------------------------
# File: modules/iam-basic/variables.tf
# Purpose:
#   Declares input interface for module 'iam-basic' (types, defaults,
# validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so
# callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Prefix used for Identity and Access Management (IAM) role
# names.
variable "name_prefix" {
  description = "Prefix used for IAM role names."
  type        = string
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
