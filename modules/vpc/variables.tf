variable "name" {
  description = "Name prefix for networking resources."
  type        = string
}

variable "cidr" {
  description = "CIDR block for VPC."
  type        = string
}

variable "az_count" {
  description = "Number of AZs to use."
  type        = number
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) > 0
    error_message = "At least one public subnet CIDR is required."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR is required."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT gateways."
  type        = bool
  default     = true
}

variable "nat_gateway_per_az" {
  description = "Whether to create one NAT gateway per AZ."
  type        = bool
  default     = true
}

variable "public_subnet_tags" {
  description = "Extra tags for public subnets."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Extra tags for private subnets."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
