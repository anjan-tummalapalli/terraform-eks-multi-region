resource "aws_security_group" "this" {
  name        = "${var.name}-ec2-sg"
  description = "Security group for EC2 instance ${var.name}"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-ec2-sg"
  })
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

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
