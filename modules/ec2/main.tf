# -----------------------------------------------------------------------------
# File: modules/ec2/main.tf
# Purpose:
#   Implements resource orchestration for module 'ec2'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Resource Purpose: Creates a security group that controls network traffic boundaries (aws_security_group.this).
resource "aws_security_group" "this" {
  name        = "${var.name}-ec2-sg"
  description = "Security group for EC2 instance ${var.name}"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-ec2-sg"
  })
}

# Resource Purpose: Defines egress permissions for a Virtual Private Cloud (VPC) security group (aws_vpc_security_group_egress_rule.all).
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# Resource Purpose: Defines ingress permissions for a Virtual Private Cloud (VPC) security group (aws_vpc_security_group_ingress_rule.this).
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for idx, rule in var.ingress_rules : idx => rule
  }

  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks[0]
  description       = try(each.value.description, null)
}

# Resource Purpose: Defines ingress permissions for a Virtual Private Cloud (VPC) security group (aws_vpc_security_group_ingress_rule.additional_cidrs).
resource "aws_vpc_security_group_ingress_rule" "additional_cidrs" {
  for_each = {
    for combo in flatten([
      for idx, rule in var.ingress_rules : [
        for cidr_idx, cidr in slice(rule.cidr_blocks, 1, length(rule.cidr_blocks)) : {
          key         = "${idx}-${cidr_idx}"
          from_port   = rule.from_port
          to_port     = rule.to_port
          protocol    = rule.protocol
          cidr_ipv4   = cidr
          description = try(rule.description, null)
        }
      ]
    ]) : combo.key => combo
  }

  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_ipv4
  description       = each.value.description
}

# Resource Purpose: Creates an Elastic Compute Cloud (EC2) instance for compute workloads (aws_instance.this).
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name
  user_data                   = var.user_data
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = var.enable_detailed_monitoring
  vpc_security_group_ids      = concat([aws_security_group.this.id], var.additional_security_group_ids)

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}
