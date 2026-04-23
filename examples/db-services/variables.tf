variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix used for resources."
  type        = string
  default     = "dbdemo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.40.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.40.1.0/24", "10.40.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = ["10.40.11.0/24", "10.40.12.0/24"]
}

variable "db_username" {
  description = "MySQL master username."
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "MySQL master password."
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Optional email subscription for SNS alerts."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Stack     = "db-services"
  }
}
