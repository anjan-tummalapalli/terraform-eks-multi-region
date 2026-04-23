variable "name_prefix" {
  description = "Prefix used for IAM role names."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
