# -----------------------------------------------------------------------------
# File: modules/ec2/variables.tf
# Purpose:
#   Declares input interface for module 'ec2' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "name" input behavior for this Terraform configuration interface.
variable "name" {
  description = "Name prefix for EC2 resources."
  type        = string
}

# Variable Purpose: Controls "vpc_id" input behavior for this Terraform configuration interface.
variable "vpc_id" {
  description = "VPC ID where the instance security group is created."
  type        = string
}

# Variable Purpose: Controls "subnet_id" input behavior for this Terraform configuration interface.
variable "subnet_id" {
  description = "Subnet ID where the EC2 instance is launched."
  type        = string
}

# Variable Purpose: Controls "ami_id" input behavior for this Terraform configuration interface.
variable "ami_id" {
  description = "AMI ID used for the EC2 instance."
  type        = string
}

# Variable Purpose: Controls "instance_type" input behavior for this Terraform configuration interface.
variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

# Variable Purpose: Controls "associate_public_ip" input behavior for this Terraform configuration interface.
variable "associate_public_ip" {
  description = "Whether to associate a public IP with the instance."
  type        = bool
  default     = true
}

# Variable Purpose: Controls "key_name" input behavior for this Terraform configuration interface.
variable "key_name" {
  description = "Optional SSH key pair name."
  type        = string
  default     = null
}

# Variable Purpose: Controls "iam_instance_profile" input behavior for this Terraform configuration interface.
variable "iam_instance_profile" {
  description = "Optional IAM instance profile name."
  type        = string
  default     = null
}

# Variable Purpose: Controls "user_data" input behavior for this Terraform configuration interface.
variable "user_data" {
  description = "Optional user data script."
  type        = string
  default     = null
}

# Variable Purpose: Controls "enable_detailed_monitoring" input behavior for this Terraform configuration interface.
variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for the instance."
  type        = bool
  default     = false
}

# Variable Purpose: Controls "root_volume_size" input behavior for this Terraform configuration interface.
variable "root_volume_size" {
  description = "Size of root EBS volume in GiB."
  type        = number
  default     = 8
}

# Variable Purpose: Controls "root_volume_type" input behavior for this Terraform configuration interface.
variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

# Variable Purpose: Controls "additional_security_group_ids" input behavior for this Terraform configuration interface.
variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the instance."
  type        = list(string)
  default     = []
}

# Variable Purpose: Controls "ingress_rules" input behavior for this Terraform configuration interface.
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

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
