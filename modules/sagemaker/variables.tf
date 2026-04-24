# -----------------------------------------------------------------------------
# File: modules/sagemaker/variables.tf
# Purpose:
#   Declares input interface for module 'sagemaker' (types, defaults,
# validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so
# callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: SageMaker notebook instance name.
variable "name" {
  description = "SageMaker notebook instance name."
  type        = string
}

# Variable Purpose: SageMaker notebook instance type.
variable "instance_type" {
  description = "SageMaker notebook instance type."
  type        = string
  default     = "ml.t3.medium"
}

# Variable Purpose: Notebook volume size in GiB.
variable "volume_size" {
  description = "Notebook volume size in GiB."
  type        = number
  default     = 5

  validation {
    condition     = var.volume_size >= 5
    error_message = "volume_size must be at least 5 GiB."
  }
}

# Variable Purpose: Subnet ID for Virtual Private Cloud (VPC)-only notebook
# deployment.
variable "subnet_id" {
  description = "Subnet ID for VPC-only notebook deployment."
  type        = string
  default     = null
}

# Variable Purpose: Security group IDs attached to notebook network interface.
variable "security_group_ids" {
  description = "Security group IDs attached to notebook network interface."
  type        = list(string)
  default     = []
}

# Variable Purpose: Enable or disable direct internet access for the notebook.
variable "direct_internet_access" {
  description = "Enable or disable direct internet access for the notebook."
  type        = string
  default     = "Disabled"

  validation {
    condition = (
      contains(["Enabled", "Disabled"], var.direct_internet_access)
    )
    error_message = "direct_internet_access must be Enabled or Disabled."
  }

  validation {
    condition = (
      var.direct_internet_access == "Enabled" ||
      (var.subnet_id != null && length(var.security_group_ids) > 0)
    )
    error_message = <<-EOT
      When direct_internet_access is Disabled, subnet_id and security_group_ids
      must be set.
    EOT
  }
}

# Variable Purpose: Enable or disable root access in the notebook.
variable "root_access" {
  description = "Enable or disable root access in the notebook."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.root_access)
    error_message = "root_access must be Enabled or Disabled."
  }
}

# Variable Purpose: Minimum IMDS version allowed for notebook instances (1 or
# 2).
variable "minimum_instance_metadata_service_version" {
  description = "Minimum IMDS version allowed for notebook instances (1 or 2)."
  type        = string
  default     = "2"

  validation {
    condition = (
      contains(["1", "2"], var.minimum_instance_metadata_service_version)
    )
    error_message = "minimum_instance_metadata_service_version must be 1 or 2."
  }
}

# Variable Purpose: Optional Key Management Service (KMS) key Amazon Resource
# Name (ARN) for notebook volume encryption.
variable "kms_key_arn" {
  description = "Optional KMS key ARN for notebook volume encryption."
  type        = string
  default     = null
}

# Variable Purpose: Whether to create an execution role for SageMaker notebook.
variable "create_execution_role" {
  description = "Whether to create an execution role for SageMaker notebook."
  type        = bool
  default     = true
}

# Variable Purpose: Optional execution role name when create_execution_role is
# true.
variable "execution_role_name" {
  description = <<-EOT
    Optional execution role name when create_execution_role is true.
  EOT
  type        = string
  default     = null
}

# Variable Purpose: Existing execution role Amazon Resource Name (ARN) when
# create_execution_role is false.
variable "execution_role_arn" {
  description = <<-EOT
    Existing execution role ARN when create_execution_role is false.
  EOT
  type        = string
  default     = null

  validation {
    condition = (
      var.create_execution_role || (
        var.execution_role_arn != null &&
        trim(var.execution_role_arn) != ""
      )
    )
    error_message = <<-EOT
      execution_role_arn must be provided when create_execution_role is false.
    EOT
  }
}

# Variable Purpose: Optional permissions boundary Amazon Resource Name (ARN)
# for created execution role.
variable "permissions_boundary_arn" {
  description = "Optional permissions boundary ARN for created execution role."
  type        = string
  default     = null
}

# Variable Purpose: Optional managed Identity and Access Management (IAM)
# policies to attach to created execution role.
variable "managed_policy_arns" {
  description = <<-EOT
    Optional managed IAM policies to attach to created execution role.
  EOT
  type        = list(string)
  default     = []
}

# Variable Purpose: Optional Simple Storage Service (S3) bucket Amazon Resource
# Names (ARNs) the notebook execution role can access.
variable "allowed_s3_bucket_arns" {
  description = <<-EOT
    Optional S3 bucket ARNs the notebook execution role can access.
  EOT
  type        = list(string)
  default     = []
}

# Variable Purpose: Whether to create a lifecycle configuration for the
# notebook.
variable "create_lifecycle_configuration" {
  description = "Whether to create a lifecycle configuration for the notebook."
  type        = bool
  default     = false
}

# Variable Purpose: Optional lifecycle configuration name when
# create_lifecycle_configuration is true.
variable "lifecycle_configuration_name" {
  description = <<-EOT
    Optional lifecycle configuration name when create_lifecycle_configuration
    is true.
  EOT
  type        = string
  default     = null
}

# Variable Purpose: Existing lifecycle configuration name to reuse when not
# creating one.
variable "existing_lifecycle_config_name" {
  description = <<-EOT
    Existing lifecycle configuration name to reuse when not creating one.
  EOT
  type        = string
  default     = null
}

# Variable Purpose: Shell script content executed on notebook creation.
variable "lifecycle_on_create" {
  description = "Shell script content executed on notebook creation."
  type        = string
  default     = null
}

# Variable Purpose: Shell script content executed on notebook start.
variable "lifecycle_on_start" {
  description = "Shell script content executed on notebook start."
  type        = string
  default     = null
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
