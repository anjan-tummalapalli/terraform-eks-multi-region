variable "name" {
  description = "SNS topic name."
  type        = string
}

variable "fifo_topic" {
  description = "Whether SNS topic is FIFO."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topic."
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "Optional KMS key ID for topic encryption."
  type        = string
  default     = null
}

variable "subscriptions" {
  description = "Topic subscriptions."
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
