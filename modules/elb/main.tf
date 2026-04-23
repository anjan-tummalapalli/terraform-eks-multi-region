locals {
  elb_name = substr(lower(replace("${var.name}-elb", "_", "-")), 0, 32)
}

resource "aws_elb" "this" {
  name                        = local.elb_name
  subnets                     = var.subnet_ids
  security_groups             = var.security_group_ids
  internal                    = var.internal
  instances                   = var.instances
  idle_timeout                = var.idle_timeout
  cross_zone_load_balancing   = var.cross_zone_load_balancing
  connection_draining         = var.connection_draining
  connection_draining_timeout = var.connection_draining_timeout

  dynamic "listener" {
    for_each = var.listeners
    content {
      instance_port      = listener.value.instance_port
      instance_protocol  = listener.value.instance_protocol
      lb_port            = listener.value.lb_port
      lb_protocol        = listener.value.lb_protocol
      ssl_certificate_id = try(listener.value.ssl_certificate_id, null)
    }
  }

  health_check {
    target              = var.health_check.target
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }

  tags = var.tags
}
