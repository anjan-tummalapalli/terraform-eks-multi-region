variable "name" {
  description = "Name prefix for EC2 resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the instance security group is created."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance is launched."
  type        = string
}

variable "ami_id" {
  description = "AMI ID used for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP with the instance."
  type        = bool
  default     = true
}

variable "key_name" {
  description = "Optional SSH key pair name."
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Optional IAM instance profile name."
  type        = string
  default     = null
}

variable "user_data" {
  description = "Optional user data script."
  type        = string
  default     = null
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for the instance."
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of root EBS volume in GiB."
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root EBS volume type."
  type        = string
  default     = "gp3"
}

variable "additional_security_group_ids" {
  description = "Additional security group IDs to attach to the instance."
  type        = list(string)
  default     = []
}

variable "ingress_rules" {
  description = "Ingress rules for the instance security group."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH access"
    }
  ]

  validation {
    condition     = alltrue([for rule in var.ingress_rules : length(rule.cidr_blocks) > 0])
    error_message = "Each ingress rule must include at least one CIDR block."
  }
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
