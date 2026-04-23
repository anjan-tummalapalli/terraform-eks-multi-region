variable "bucket_name" {
  description = "Unique S3 bucket name."
  type        = string
}

variable "versioning_enabled" {
  description = "Enable object versioning."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow bucket destruction even when non-empty."
  type        = bool
  default     = false
}

variable "enable_lifecycle_rule" {
  description = "Enable lifecycle expiration rule."
  type        = bool
  default     = false
}

variable "lifecycle_expiration_days" {
  description = "Expiration in days for lifecycle rule."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
