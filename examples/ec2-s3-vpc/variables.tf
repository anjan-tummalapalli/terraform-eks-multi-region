# -----------------------------------------------------------------------------
# File: examples/ec2-s3-vpc/variables.tf
# Purpose:
#   Defines configurable inputs for example 'ec2-s3-vpc'.
# Why this file exists:
#   Separates environment-specific values from example logic so users can copy and adapt safely.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "region" input behavior for this Terraform configuration interface.
variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Controls "name_prefix" input behavior for this Terraform configuration interface.
variable "name_prefix" {
  description = "Prefix used for resources."
  type        = string
  default     = "demo"
}

# Variable Purpose: Controls "vpc_cidr" input behavior for this Terraform configuration interface.
variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.30.0.0/16"
}

# Variable Purpose: Controls "public_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.30.1.0/24", "10.30.2.0/24"]
}

# Variable Purpose: Controls "private_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = ["10.30.11.0/24", "10.30.12.0/24"]
}

# Variable Purpose: Controls "bucket_name" input behavior for this Terraform configuration interface.
variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

# Variable Purpose: Controls "instance_type" input behavior for this Terraform configuration interface.
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

# Variable Purpose: Controls "ingress_cidrs" input behavior for this Terraform configuration interface.
variable "ingress_cidrs" {
  description = "CIDR blocks allowed for SSH access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
