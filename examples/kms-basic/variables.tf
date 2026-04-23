variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for naming resources."
  type        = string
  default     = "kms-demo"
}

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "admin_principal_arns" {
  description = "Optional IAM principal ARNs with full admin permissions on KMS key."
  type        = list(string)
  default     = []
}

variable "usage_principal_arns" {
  description = "Optional IAM principal ARNs allowed cryptographic key usage."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "kms"
  }
}
