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

# Variable Purpose: Amazon Web Services (AWS) region.
variable "region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

# Variable Purpose: Prefix used for resources.
variable "name_prefix" {
  description = "Prefix used for resources."
  type        = string
  default     = "demo"
}

# Variable Purpose: Virtual Private Cloud (VPC) Classless Inter-Domain Routing (CIDR) block.
variable "vpc_cidr" {
  description = "VPC CIDR block."
  type        = string
  default     = "10.30.0.0/16"
}

# Variable Purpose: Public subnet Classless Inter-Domain Routing blocks (CIDRs).
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs."
  type        = list(string)
  default     = ["10.30.1.0/24", "10.30.2.0/24"]
}

# Variable Purpose: Private subnet Classless Inter-Domain Routing blocks (CIDRs).
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs."
  type        = list(string)
  default     = ["10.30.11.0/24", "10.30.12.0/24"]
}

# Variable Purpose: Globally unique Simple Storage Service (S3) bucket name.
variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

# Variable Purpose: Elastic Compute Cloud (EC2) instance type.
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) blocks allowed for SSH access.
variable "ingress_cidrs" {
  description = "CIDR blocks allowed for SSH access."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    ManagedBy = "terraform"
  }
}
