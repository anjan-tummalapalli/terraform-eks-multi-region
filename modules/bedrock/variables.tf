# -----------------------------------------------------------------------------
# File: modules/bedrock/variables.tf
# Purpose:
#   Declares input interface for module 'bedrock' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "name_prefix" input behavior for this Terraform configuration interface.
variable "name_prefix" {
  description = "Prefix used for Bedrock logging resources."
  type        = string
  default     = "bedrock"
}

# Variable Purpose: Controls "enable_cloudwatch_logging" input behavior for this Terraform configuration interface.
variable "enable_cloudwatch_logging" {
  description = "Whether to enable Bedrock invocation logging to CloudWatch."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "create_cloudwatch_log_group" input behavior for this Terraform configuration interface.
variable "create_cloudwatch_log_group" {
  description = "Whether to create CloudWatch log group for Bedrock logging."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "cloudwatch_log_group_name" input behavior for this Terraform configuration interface.
variable "cloudwatch_log_group_name" {
  description = "Optional existing CloudWatch log group name for Bedrock logging."
  type        = string
  default     = null

  validation {
    condition     = var.cloudwatch_log_group_name == null || trim(var.cloudwatch_log_group_name) != ""
    error_message = "cloudwatch_log_group_name cannot be an empty string."
  }
}

# Variable Purpose: Controls "cloudwatch_log_retention_in_days" input behavior for this Terraform configuration interface.
variable "cloudwatch_log_retention_in_days" {
  description = "Retention period in days for Bedrock CloudWatch logs."
  type        = number
  default     = 7

  validation {
    condition     = var.cloudwatch_log_retention_in_days >= 1
    error_message = "cloudwatch_log_retention_in_days must be at least 1 day."
  }
}

# Variable Purpose: Controls "cloudwatch_kms_key_id" input behavior for this Terraform configuration interface.
variable "cloudwatch_kms_key_id" {
  description = "Optional KMS key ID/ARN for CloudWatch log encryption."
  type        = string
  default     = null
}

# Variable Purpose: Controls "create_logging_role" input behavior for this Terraform configuration interface.
variable "create_logging_role" {
  description = "Whether to create IAM role used by Bedrock for log delivery."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "logging_role_name" input behavior for this Terraform configuration interface.
variable "logging_role_name" {
  description = "Optional name for created Bedrock logging role."
  type        = string
  default     = null
}

# Variable Purpose: Controls "logging_role_arn" input behavior for this Terraform configuration interface.
variable "logging_role_arn" {
  description = "Existing IAM role ARN for Bedrock log delivery when create_logging_role is false."
  type        = string
  default     = null

  validation {
    condition     = var.logging_role_arn == null || trim(var.logging_role_arn) != ""
    error_message = "logging_role_arn cannot be an empty string."
  }
}

# Variable Purpose: Controls "s3_bucket_name" input behavior for this Terraform configuration interface.
variable "s3_bucket_name" {
  description = "Optional S3 bucket name for Bedrock invocation log delivery."
  type        = string
  default     = null

  validation {
    condition     = var.s3_bucket_name == null || trim(var.s3_bucket_name) != ""
    error_message = "s3_bucket_name cannot be an empty string."
  }
}

# Variable Purpose: Controls "s3_key_prefix" input behavior for this Terraform configuration interface.
variable "s3_key_prefix" {
  description = "Optional key prefix for Bedrock invocation logs in S3."
  type        = string
  default     = "bedrock/model-invocations/"
}

# Variable Purpose: Controls "text_data_delivery_enabled" input behavior for this Terraform configuration interface.
variable "text_data_delivery_enabled" {
  description = "Enable logging of text payloads."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "image_data_delivery_enabled" input behavior for this Terraform configuration interface.
variable "image_data_delivery_enabled" {
  description = "Enable logging of image payloads."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "embedding_data_delivery_enabled" input behavior for this Terraform configuration interface.
variable "embedding_data_delivery_enabled" {
  description = "Enable logging of embedding payloads."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "video_data_delivery_enabled" input behavior for this Terraform configuration interface.
variable "video_data_delivery_enabled" {
  description = "Enable logging of video payloads."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
