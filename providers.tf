# -----------------------------------------------------------------------------
# File: providers.tf
# Purpose:
#   Defines provider configuration and aliases used by the root stack.
# Why this file exists:
#   Centralizes provider setup to avoid drift and alias mismatches across modules.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

provider "aws" {
  alias  = "primary"
  region = var.primary_region
  # Ternary Purpose: Selects the "profile" value by evaluating a condition and choosing true/false branches explicitly.
  profile = var.aws_profile != "" ? var.aws_profile : null
}

provider "aws" {
  alias  = "dr"
  region = var.dr_region
  # Ternary Purpose: Selects the "profile" value by evaluating a condition and choosing true/false branches explicitly.
  profile = var.aws_profile != "" ? var.aws_profile : null
}
