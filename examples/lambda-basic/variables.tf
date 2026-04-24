# -----------------------------------------------------------------------------
# File: examples/lambda-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'lambda-basic'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "AWS region for Lambda deployment."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Controls "function_name" input behavior for this Terraform configuration interface.
variable "function_name" {
  description = "Lambda function name."
  type        = string
  default     = "example-hello-lambda"
}

# Variable Purpose: Controls "runtime" input behavior for this Terraform configuration interface.
variable "runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "python3.12"
}

# Variable Purpose: Controls "handler" input behavior for this Terraform configuration interface.
variable "handler" {
  description = "Lambda handler."
  type        = string
  default     = "handler.lambda_handler"
}

# Variable Purpose: Controls "memory_size" input behavior for this Terraform configuration interface.
variable "memory_size" {
  description = "Lambda memory in MB."
  type        = number
  default     = 256
}

# Variable Purpose: Controls "timeout" input behavior for this Terraform configuration interface.
variable "timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 10
}

# Variable Purpose: Controls "log_retention_days" input behavior for this Terraform configuration interface.
variable "log_retention_days" {
  description = "CloudWatch log retention for Lambda logs."
  type        = number
  default     = 14
}

# Variable Purpose: Controls "environment_variables" input behavior for this Terraform configuration interface.
variable "environment_variables" {
  description = "Environment variables for Lambda function."
  type        = map(string)
  default = {
    STAGE = "dev"
  }
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "lambda"
  }
}
