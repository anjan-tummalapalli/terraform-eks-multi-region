# -----------------------------------------------------------------------------
# File: modules/lambda-function/variables.tf
# Purpose:
#   Declares input interface for module 'lambda-function' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "function_name" input behavior for this Terraform configuration interface.
variable "function_name" {
  description = "Lambda function name."
  type        = string
}

# Variable Purpose: Controls "filename" input behavior for this Terraform configuration interface.
variable "filename" {
  description = "Path to deployment package zip file."
  type        = string
}

# Variable Purpose: Controls "handler" input behavior for this Terraform configuration interface.
variable "handler" {
  description = "Function handler entrypoint."
  type        = string
}

# Variable Purpose: Controls "runtime" input behavior for this Terraform configuration interface.
variable "runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "python3.12"
}

# Variable Purpose: Controls "timeout" input behavior for this Terraform configuration interface.
variable "timeout" {
  description = "Function timeout in seconds."
  type        = number
  default     = 30
}

# Variable Purpose: Controls "memory_size" input behavior for this Terraform configuration interface.
variable "memory_size" {
  description = "Function memory in MB."
  type        = number
  default     = 128
}

# Variable Purpose: Controls "environment_variables" input behavior for this Terraform configuration interface.
variable "environment_variables" {
  description = "Environment variables for Lambda."
  type        = map(string)
  default     = {}
}

# Variable Purpose: Controls "log_retention_days" input behavior for this Terraform configuration interface.
variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 7
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
