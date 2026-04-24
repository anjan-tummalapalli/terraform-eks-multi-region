# -----------------------------------------------------------------------------
# File: modules/ec2/variables.tf
# Purpose:
#   Declares input interface for module 'ec2' (types, defaults, validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Name prefix for Elastic Compute Cloud (EC2) resources.
variable "name" {
  description = "Name prefix for EC2 resources."
  type        = string
}

# Variable Purpose: Virtual Private Cloud (VPC) ID where the instance security group is created.
variable "vpc_id" {
  description = "VPC ID where the instance security group is created."
  type        = string
}

# Variable Purpose: Subnet ID where the Elastic Compute Cloud (EC2) instance is launched.
variable "subnet_id" {
  description = "Subnet ID where the EC2 instance is launched."
  type        = string
}

# Variable Purpose: Amazon Machine Image (AMI) ID used for the Elastic Compute Cloud (EC2) instance.
variable "ami_id" {
  description = "AMI ID used for the EC2 instance."
  type        = string
}

# Variable Purpose: Elastic Compute Cloud (EC2) instance type.
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

# Variable Purpose: Whether to associate a public IP with the instance.
variable "associate_public_ip" {
  description = "Whether to associate a public IP with the instance."
  type        = bool
  default     = true
}

# Variable Purpose: Optional SSH key pair name.
variable "key_name" {
  description = "Optional SSH key pair name."
  type        = string
  default     = null
}

# Variable Purpose: Optional Identity and Access Management (IAM) instance profile name.
variable "iam_instance_profile" {
  description = "Optional IAM instance profile name."
  type        = string
  default     = null
}

# Variable Purpose: Optional user data script.
variable "user_data" {
  description = "Optional user data script."
  type        = string
  default     = null
}

# Variable Purpose: Enable detailed monitoring for the instance.
variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for the instance."
  type        = bool
  default     = false
}

# Variable Purpose: Size of root EBS volume in GiB.
variable "root_volume_size" {
  description = "Size of root EBS volume in GiB."
  type        = number
  default     = 8
}

# Variable Purpose: Root EBS volume type.
variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

# Variable Purpose: Additional security group IDs to attach to the instance.
variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the instance."
  type        = list(string)
  default     = []
}

# Variable Purpose: Ingress rules for the instance security group.
variable "ingress_rules" {
  description = "Ingress rules for the instance security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = []

  validation {
    condition     = alltrue([for rule in var.ingress_rules : length(rule.cidr_blocks) > 0])
    error_message = "Each ingress rule must include at least one CIDR block."
  }
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
