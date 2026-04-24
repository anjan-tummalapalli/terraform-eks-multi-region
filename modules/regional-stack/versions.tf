# -----------------------------------------------------------------------------
# File: modules/regional-stack/versions.tf
# Purpose:
#   Pins Terraform/provider compatibility for module 'regional-stack'.
# Why this file exists:
#   Helps keep upgrades deliberate and reproducible across environments.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
