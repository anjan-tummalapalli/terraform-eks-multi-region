# -----------------------------------------------------------------------------
# File: modules/kms/variables.tf
# Purpose:
#   Declares input interface for module 'kms' (types, defaults, validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Base name used for Key Management Service (KMS) key alias and tags.
variable "name" {
  description = "Base name used for KMS key alias and tags."
  type        = string
}

# Variable Purpose: Description for the Key Management Service (KMS) key.
variable "description" {
  description = "Description for the KMS key."
  type        = string
  default     = "Customer managed KMS key"
}

# Variable Purpose: Cryptographic operations for which the key can be used.
variable "key_usage" {
  description = "Cryptographic operations for which the key can be used."
  type        = string
  default     = "ENCRYPT_DECRYPT"

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
    error_message = "key_usage must be ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC."
  }
}

# Variable Purpose: Type of Key Management Service (KMS) key material to create.
variable "key_spec" {
  description = "Type of KMS key material to create."
  type        = string
  default     = "SYMMETRIC_DEFAULT"

  validation {
    condition = contains([
      "SYMMETRIC_DEFAULT",
      "RSA_2048",
      "RSA_3072",
      "RSA_4096",
      "ECC_NIST_P256",
      "ECC_NIST_P384",
      "ECC_NIST_P521",
      "ECC_SECG_P256K1",
      "HMAC_224",
      "HMAC_256",
      "HMAC_384",
      "HMAC_512"
    ], var.key_spec)
    error_message = "Unsupported key_spec value."
  }
}

# Variable Purpose: Enable annual key rotation for symmetric customer managed keys.
variable "enable_key_rotation" {
  description = "Enable annual key rotation for symmetric customer managed keys."
  type        = bool
  default     = true

  validation {
    condition     = var.key_spec == "SYMMETRIC_DEFAULT" || var.enable_key_rotation == false
    error_message = "enable_key_rotation can be true only when key_spec is SYMMETRIC_DEFAULT."
  }
}

# Variable Purpose: Whether the Key Management Service (KMS) key is enabled.
variable "is_enabled" {
  description = "Whether the KMS key is enabled."
  type        = bool
  default     = true
}

# Variable Purpose: Whether to create a multi-Region Key Management Service (KMS) key.
variable "multi_region" {
  description = "Whether to create a multi-Region KMS key."
  type        = bool
  default     = false
}

# Variable Purpose: Deletion window in days if key is scheduled for deletion.
variable "deletion_window_in_days" {
  description = "Deletion window in days if key is scheduled for deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30."
  }
}

# Variable Purpose: Whether to create a primary alias for this key.
variable "create_alias" {
  description = "Whether to create a primary alias for this key."
  type        = bool
  default     = true
}

# Variable Purpose: Alias name without the alias/ prefix.
variable "alias_name" {
  description = "Alias name without the alias/ prefix."
  type        = string
  default     = null
}

# Variable Purpose: Additional alias names (without alias/ prefix).
variable "additional_aliases" {
  description = "Additional alias names (without alias/ prefix)."
  type        = list(string)
  default     = []
}

# Variable Purpose: Identity and Access Management (IAM) principal Amazon Resource Names (ARNs) allowed full administrative control of this key.
variable "admin_principal_arns" {
  description = "IAM principal ARNs allowed full administrative control of this key."
  type        = list(string)
  default     = []
}

# Variable Purpose: Identity and Access Management (IAM) principal Amazon Resource Names (ARNs) allowed key usage operations.
variable "usage_principal_arns" {
  description = "IAM principal ARNs allowed key usage operations."
  type        = list(string)
  default     = []
}

# Variable Purpose: Service principal names allowed key usage (for example s3.amazonaws.com).
variable "service_principals" {
  description = "Service principal names allowed key usage (for example s3.amazonaws.com)."
  type        = list(string)
  default     = []
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
