# -----------------------------------------------------------------------------
# File: modules/vpc/variables.tf
# Purpose:
#   Declares input interface for module 'vpc' (types, defaults, validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Name prefix for networking resources.
variable "name" {
  description = "Name prefix for networking resources."
  type        = string
}

# Variable Purpose: Classless Inter-Domain Routing (CIDR) block for Virtual Private Cloud (VPC).
variable "cidr" {
  description = "CIDR block for VPC."
  type        = string
}

# Variable Purpose: Number of Availability Zones (AZs) to use.
variable "az_count" {
  description = "Number of AZs to use."
  type        = number
}

# Variable Purpose: Classless Inter-Domain Routing blocks (CIDRs) for public subnets.
variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "At least one public subnet CIDR is required."
  }
}

# Variable Purpose: Classless Inter-Domain Routing blocks (CIDRs) for private subnets.
variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR is required."
  }
}

# Variable Purpose: Whether to create Network Address Translation (NAT) gateways.
variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways."
  type        = bool
  default     = true
}

# Variable Purpose: Whether to create one Network Address Translation (NAT) gateway per Availability Zone (AZ).
variable "nat_gateway_per_az" {
  description = "Whether to create one NAT gateway per AZ."
  type        = bool
  default     = false
}

# Variable Purpose: Extra tags for public subnets.
variable "public_subnet_tags" {
  description = "Extra tags for public subnets."
  type        = map(string)
  default     = {}
}

# Variable Purpose: Extra tags for private subnets.
variable "private_subnet_tags" {
  description = "Extra tags for private subnets."
  type        = map(string)
  default     = {}
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
