# -----------------------------------------------------------------------------
# File: modules/vpc/variables.tf
# Purpose:
#   Declares input interface for module 'vpc' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "name" input behavior for this Terraform configuration interface.
variable "name" {
  description = "Name prefix for networking resources."
  type        = string
}

# Variable Purpose: Controls "cidr" input behavior for this Terraform configuration interface.
variable "cidr" {
  description = "CIDR block for VPC."
  type        = string
}

# Variable Purpose: Controls "az_count" input behavior for this Terraform configuration interface.
variable "az_count" {
  description = "Number of AZs to use."
  type        = number
}

# Variable Purpose: Controls "public_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "At least one public subnet CIDR is required."
  }
}

# Variable Purpose: Controls "private_subnet_cidrs" input behavior for this Terraform configuration interface.
variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR is required."
  }
}

# Variable Purpose: Controls "enable_nat_gateway" input behavior for this Terraform configuration interface.
variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "nat_gateway_per_az" input behavior for this Terraform configuration interface.
variable "nat_gateway_per_az" {
  description = "Whether to create one NAT gateway per AZ."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "public_subnet_tags" input behavior for this Terraform configuration interface.
variable "public_subnet_tags" {
  description = "Extra tags for public subnets."
  type        = map(string)
  default     = {}
}

# Variable Purpose: Controls "private_subnet_tags" input behavior for this Terraform configuration interface.
variable "private_subnet_tags" {
  description = "Extra tags for private subnets."
  type        = map(string)
  default     = {}
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
