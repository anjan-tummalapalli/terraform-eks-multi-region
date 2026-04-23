variable "region" {
  description = "AWS region for CloudWatch resources."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for resource naming."
  type        = string
  default     = "cw-demo"
}

variable "alert_email" {
  description = "Optional email address for CloudWatch alarm notifications."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "cloudwatch"
  }
}
