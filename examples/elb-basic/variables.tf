# -----------------------------------------------------------------------------
# File: examples/elb-basic/variables.tf
# Purpose:
#   Defines configurable inputs for example 'elb-basic'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
  default     = "elb-demo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.50.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks."
  type        = list(string)
  default     = ["10.50.1.0/24", "10.50.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks."
  type        = list(string)
  default     = ["10.50.11.0/24", "10.50.12.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for backend host."
  type        = string
  default     = "t3.micro"
}

variable "ssh_ingress_cidrs" {
  description = "CIDRs allowed for SSH access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "elb_ingress_cidrs" {
  description = "CIDRs allowed to access the ELB listener."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Service   = "elb"
  }
}
