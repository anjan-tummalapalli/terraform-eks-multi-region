# -----------------------------------------------------------------------------
# File: examples/ecr-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'ecr-basic'.
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

# Variable Purpose: Amazon Web Services (AWS) region for Elastic Container
# Registry (ECR) resources.
variable "region" {
  description = "AWS region for Elastic Container Registry (ECR) resources."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Elastic Container Registry (ECR) repository name.
variable "repository_name" {
  description = "Elastic Container Registry (ECR) repository name."
  type        = string
  default     = "ecr-demo-app"
}

# Variable Purpose: Repository tag mutability mode.
variable "image_tag_mutability" {
  description = "Repository tag mutability mode."
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

# Variable Purpose: Enable image vulnerability scans on push.
variable "scan_on_push" {
  description = "Enable image vulnerability scans on push."
  type        = bool
  default     = true
}

# Variable Purpose: Encryption type for repository images.
variable "encryption_type" {
  description = "Encryption type for repository images."
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS."
  }
}

# Variable Purpose: Optional Key Management Service (KMS) key Amazon Resource
# Name (ARN) when encryption_type is KMS.
variable "kms_key_arn" {
  description = <<-EOT
    Optional Key Management Service (KMS) key Amazon Resource Name (ARN) when
    encryption_type is KMS.
  EOT
  type        = string
  default     = null

  validation {
    condition = (
      var.encryption_type == "AES256" && var.kms_key_arn == null
      ) || (
      var.encryption_type == "KMS" && var.kms_key_arn != null
    )
    error_message = <<-EOT
      kms_key_arn must be set when encryption_type is KMS, and null when
      encryption_type is AES256.
    EOT
  }
}

# Variable Purpose: Whether to allow deleting the repository even when it
# contains images.
variable "force_delete" {
  description = <<-EOT
    Whether to allow deleting the repository even when it contains images.
  EOT
  type        = bool
  default     = false
}

# Variable Purpose: Number of images to keep before lifecycle expiration starts.
variable "lifecycle_max_image_count" {
  description = "Number of images to keep before lifecycle expiration starts."
  type        = number
  default     = 20

  validation {
    condition     = var.lifecycle_max_image_count > 0
    error_message = "lifecycle_max_image_count must be greater than zero."
  }
}

# Variable Purpose: Lifecycle rule tag status filter (tagged, untagged, or any).
variable "lifecycle_tag_status" {
  description = "Lifecycle rule tag status filter (tagged, untagged, or any)."
  type        = string
  default     = "any"

  validation {
    condition = (
      contains(["tagged", "untagged", "any"], var.lifecycle_tag_status)
    )
    error_message = "lifecycle_tag_status must be tagged, untagged, or any."
  }
}

# Variable Purpose: Tag prefixes used when lifecycle_tag_status is tagged.
variable "lifecycle_tag_prefix_list" {
  description = "Tag prefixes used when lifecycle_tag_status is tagged."
  type        = list(string)
  default     = []

  validation {
    condition = (
      (
        var.lifecycle_tag_status == "tagged" &&
        length(var.lifecycle_tag_prefix_list) > 0
        ) || (
        var.lifecycle_tag_status != "tagged" &&
        length(var.lifecycle_tag_prefix_list) == 0
      )
    )
    error_message = <<-EOT
      lifecycle_tag_prefix_list must be non-empty when lifecycle_tag_status is
      tagged, and empty otherwise.
    EOT
  }
}

# Variable Purpose: Optional Amazon Resource Names (ARNs) allowed to pull
# images from this repository.
variable "repository_pull_principal_arns" {
  description = <<-EOT
    Optional Amazon Resource Names (ARNs) allowed to pull images from this
    repository.
  EOT
  type        = list(string)
  default     = []
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "ecr"
  }
}
