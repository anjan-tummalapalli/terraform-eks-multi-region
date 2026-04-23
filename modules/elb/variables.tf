variable "name" {
  description = "Name prefix for ELB resources."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where ELB is deployed."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs attached to ELB."
  type        = list(string)
}

variable "internal" {
  description = "Whether the ELB is internal."
  type        = bool
  default     = false
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing."
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Connection idle timeout in seconds."
  type        = number
  default     = 60
}

variable "connection_draining" {
  description = "Enable connection draining."
  type        = bool
  default     = true
}

variable "connection_draining_timeout" {
  description = "Connection draining timeout in seconds."
  type        = number
  default     = 120
}

variable "instances" {
  description = "Instance IDs registered behind ELB."
  type        = list(string)
  default     = []
}

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

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
