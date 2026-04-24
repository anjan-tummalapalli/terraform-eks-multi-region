# -----------------------------------------------------------------------------
# File: modules/elb/variables.tf
# Purpose:
#   Declares input interface for module 'elb' (types, defaults, validation).
# Why this file exists:
#   Acts as the module Application Programming Interface (API) boundary so
# callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Name prefix for Elastic Load Balancer (ELB) resources.
variable "name" {
  description = "Name prefix for ELB resources."
  type        = string
}

# Variable Purpose: Subnet IDs where Elastic Load Balancer (ELB) is deployed.
variable "subnet_ids" {
  description = "Subnet IDs where ELB is deployed."
  type        = list(string)
}

# Variable Purpose: Security group IDs attached to Elastic Load Balancer (ELB).
variable "security_group_ids" {
  description = "Security group IDs attached to ELB."
  type        = list(string)
}

# Variable Purpose: Whether the Elastic Load Balancer (ELB) is internal.
variable "internal" {
  description = "Whether the ELB is internal."
  type        = bool
  default     = false
}

# Variable Purpose: Enable cross-zone load balancing (set true for High
# Availability (HA), false for lower cross-Availability Zone (AZ) data cost).
variable "cross_zone_load_balancing" {
  description = <<-EOT
    Enable cross-zone load balancing (set true for HA, false for lower cross-AZ
    data cost).
  EOT
  type        = bool
  default     = false
}

# Variable Purpose: Connection idle timeout in seconds.
variable "idle_timeout" {
  description = "Connection idle timeout in seconds."
  type        = number
  default     = 60
}

# Variable Purpose: Enable connection draining.
variable "connection_draining" {
  description = "Enable connection draining."
  type        = bool
  default     = true
}

# Variable Purpose: Connection draining timeout in seconds.
variable "connection_draining_timeout" {
  description = "Connection draining timeout in seconds."
  type        = number
  default     = 120
}

# Variable Purpose: Instance IDs registered behind Elastic Load Balancer (ELB).
variable "instances" {
  description = "Instance IDs registered behind ELB."
  type        = list(string)
  default     = []
}

# Variable Purpose: Listener definitions for Elastic Load Balancer (ELB).
variable "listeners" {
  description = "Listener definitions for ELB."
  type = list(object({
    instance_port      = number
    instance_protocol  = string
    lb_port            = number
    lb_protocol        = string
    ssl_certificate_id = optional(string)
  }))
  default = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    }
  ]
}

# Variable Purpose: Health check configuration.
variable "health_check" {
  description = "Health check configuration."
  type = object({
    target              = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
  })
  default = {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Variable Purpose: Common tags.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
