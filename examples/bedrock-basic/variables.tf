# -----------------------------------------------------------------------------
# File: examples/bedrock-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'bedrock-basic'.
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

# Variable Purpose: Amazon Web Services (AWS) region for Bedrock logging
# configuration.
variable "region" {
  description = "AWS region for Bedrock logging configuration."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Prefix used for Bedrock logging resources.
variable "name_prefix" {
  description = "Prefix used for Bedrock logging resources."
  type        = string
  default     = "bedrock-demo"
}

# Variable Purpose: Globally unique Simple Storage Service (S3) bucket name for
# Bedrock invocation log delivery.
variable "bedrock_logs_bucket_name" {
  description = <<-EOT
    Globally unique S3 bucket name for Bedrock invocation log delivery.
  EOT
  type        = string
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "bedrock"
  }
}
