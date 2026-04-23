variable "function_name" {
  description = "Lambda function name."
  type        = string
}

variable "filename" {
  description = "Path to deployment package zip file."
  type        = string
}

variable "handler" {
  description = "Function handler entrypoint."
  type        = string
}

variable "runtime" {
  description = "Lambda runtime."
  type        = string
  default     = "python3.12"
}

variable "timeout" {
  description = "Function timeout in seconds."
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Function memory in MB."
  type        = number
  default     = 128
}

variable "environment_variables" {
  description = "Environment variables for Lambda."
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
