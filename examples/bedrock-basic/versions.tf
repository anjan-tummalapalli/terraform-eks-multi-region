# -----------------------------------------------------------------------------
# File: examples/bedrock-basic/versions.tf
# Purpose:
#   Pins Terraform/provider compatibility for example 'bedrock-basic'.
# Why this file exists:
#   Ensures example behavior remains reproducible during provider/module
# evolution.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
