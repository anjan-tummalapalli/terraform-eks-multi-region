# -----------------------------------------------------------------------------
# File: modules/sagemaker/variables.tf
# Purpose:
#   Declares input interface for module 'sagemaker' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "name" {
  description = "SageMaker notebook instance name."
  type        = string
}

variable "instance_type" {
  description = "SageMaker notebook instance type."
  type        = string
  default     = "ml.t3.medium"
}

variable "volume_size" {
  description = "Notebook volume size in GiB."
  type        = number
  default     = 5

  validation {
    condition     = var.volume_size >= 5
    error_message = "volume_size must be at least 5 GiB."
  }
}

variable "subnet_id" {
  description = "Subnet ID for VPC-only notebook deployment."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs attached to notebook network interface."
  type        = list(string)
  default     = []
}

variable "direct_internet_access" {
  description = "Enable or disable direct internet access for the notebook."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.direct_internet_access)
    error_message = "direct_internet_access must be Enabled or Disabled."
  }

  validation {
    condition = (
      var.direct_internet_access == "Enabled" ||
      (var.subnet_id != null && length(var.security_group_ids) > 0)
    )
    error_message = "When direct_internet_access is Disabled, subnet_id and security_group_ids must be set."
  }
}

variable "root_access" {
  description = "Enable or disable root access in the notebook."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.root_access)
    error_message = "root_access must be Enabled or Disabled."
  }
}

variable "minimum_instance_metadata_service_version" {
  description = "Minimum IMDS version allowed for notebook instances (1 or 2)."
  type        = string
  default     = "2"

  validation {
    condition     = contains(["1", "2"], var.minimum_instance_metadata_service_version)
    error_message = "minimum_instance_metadata_service_version must be 1 or 2."
  }
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN for notebook volume encryption."
  type        = string
  default     = null
}

variable "create_execution_role" {
  description = "Whether to create an execution role for SageMaker notebook."
  type        = bool
  default     = true
}

variable "execution_role_name" {
  description = "Optional execution role name when create_execution_role is true."
  type        = string
  default     = null
}

variable "execution_role_arn" {
  description = "Existing execution role ARN when create_execution_role is false."
  type        = string
  default     = null

  validation {
    condition     = var.create_execution_role || (var.execution_role_arn != null && trim(var.execution_role_arn) != "")
    error_message = "execution_role_arn must be provided when create_execution_role is false."
  }
}

variable "permissions_boundary_arn" {
  description = "Optional permissions boundary ARN for created execution role."
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "Optional managed IAM policies to attach to created execution role."
  type        = list(string)
  default     = []
}

variable "allowed_s3_bucket_arns" {
  description = "Optional S3 bucket ARNs the notebook execution role can access."
  type        = list(string)
  default     = []
}

variable "create_lifecycle_configuration" {
  description = "Whether to create a lifecycle configuration for the notebook."
  type        = bool
  default     = false
}

variable "lifecycle_configuration_name" {
  description = "Optional lifecycle configuration name when create_lifecycle_configuration is true."
  type        = string
  default     = null
}

variable "existing_lifecycle_config_name" {
  description = "Existing lifecycle configuration name to reuse when not creating one."
  type        = string
  default     = null
}

variable "lifecycle_on_create" {
  description = "Shell script content executed on notebook creation."
  type        = string
  default     = null
}

variable "lifecycle_on_start" {
  description = "Shell script content executed on notebook start."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
