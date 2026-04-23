variable "name" {
  description = "Base name used for KMS key alias and tags."
  type        = string
}

variable "description" {
  description = "Description for the KMS key."
  type        = string
  default     = "Customer managed KMS key"
}

variable "key_usage" {
  description = "Cryptographic operations for which the key can be used."
  type        = string
  default     = "ENCRYPT_DECRYPT"

  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
    error_message = "key_usage must be ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC."
  }
}

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

variable "enable_key_rotation" {
  description = "Enable annual key rotation for symmetric customer managed keys."
  type        = bool
  default     = true

  validation {
    condition     = var.key_spec == "SYMMETRIC_DEFAULT" || var.enable_key_rotation == false
    error_message = "enable_key_rotation can be true only when key_spec is SYMMETRIC_DEFAULT."
  }
}

variable "is_enabled" {
  description = "Whether the KMS key is enabled."
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Whether to create a multi-Region KMS key."
  type        = bool
  default     = false
}

variable "deletion_window_in_days" {
  description = "Deletion window in days if key is scheduled for deletion."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30."
  }
}

variable "create_alias" {
  description = "Whether to create a primary alias for this key."
  type        = bool
  default     = true
}

variable "alias_name" {
  description = "Alias name without the alias/ prefix."
  type        = string
  default     = null
}

variable "additional_aliases" {
  description = "Additional alias names (without alias/ prefix)."
  type        = list(string)
  default     = []
}

variable "admin_principal_arns" {
  description = "IAM principal ARNs allowed full administrative control of this key."
  type        = list(string)
  default     = []
}

variable "usage_principal_arns" {
  description = "IAM principal ARNs allowed key usage operations."
  type        = list(string)
  default     = []
}

variable "service_principals" {
  description = "Service principal names allowed key usage (for example s3.amazonaws.com)."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
