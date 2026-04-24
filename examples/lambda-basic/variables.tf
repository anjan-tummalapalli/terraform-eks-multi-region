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

# Variable Purpose: Amazon Web Services (AWS) region for Lambda deployment.
variable "region" {
  description = "AWS region for Lambda deployment."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Lambda function name.
variable "function_name" {
  description = "Lambda function name."
  type        = string
  default     = "example-hello-lambda"
}

# Variable Purpose: Lambda runtime.
variable "runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "python3.12"
}

# Variable Purpose: Lambda handler.
variable "handler" {
  description = "Lambda handler."
  type        = string
  default     = "handler.lambda_handler"
}

# Variable Purpose: Lambda memory in MB.
variable "memory_size" {
  description = "Lambda memory in MB."
  type        = number
  default     = 256
}

# Variable Purpose: Lambda timeout in seconds.
variable "timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 10
}

# Variable Purpose: CloudWatch log retention for Lambda logs.
variable "log_retention_days" {
  description = "CloudWatch log retention for Lambda logs."
  type        = number
  default     = 14
}

# Variable Purpose: Environment variables for Lambda function.
variable "environment_variables" {
  description = "Environment variables for Lambda function."
  type        = map(string)
  default = {
    STAGE = "dev"
  }
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "lambda"
  }
}
