provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = "${var.name_prefix}-core"
  cidr                 = var.vpc_cidr
  az_count             = 2
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = false
  nat_gateway_per_az   = false
  tags                 = var.tags
}

resource "aws_security_group" "elb" {
  name        = "${var.name_prefix}-elb-sg"
  description = "Security group for classic ELB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.elb_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-elb-sg"
  })
}

resource "aws_security_group" "instance_from_elb" {
  name        = "${var.name_prefix}-instance-from-elb-sg"
  description = "Allow HTTP from ELB to EC2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-instance-from-elb-sg"
  })
}

module "ec2" {
  source = "../../modules/ec2"

  name                = "${var.name_prefix}-app"
  vpc_id              = module.vpc.vpc_id
  subnet_id           = module.vpc.public_subnet_ids[0]
  ami_id              = data.aws_ssm_parameter.al2023.value
  instance_type       = var.instance_type
  associate_public_ip = true
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_ingress_cidrs
      description = "Allow SSH"
    }
  ]
  additional_security_group_ids = [aws_security_group.instance_from_elb.id]
  user_data                     = <<-EOT
    #!/bin/bash
    set -eux
    dnf install -y python3
    cat > /home/ec2-user/index.html <<'HTML'
    <html><body><h1>Classic ELB Backend Healthy</h1></body></html>
    HTML
    nohup python3 -m http.server 80 --directory /home/ec2-user >/var/log/http-server.log 2>&1 &
  EOT
  tags                          = var.tags
}

module "elb" {
  source = "../../modules/elb"

  name               = var.name_prefix
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.elb.id]
  instances          = [module.ec2.instance_id]
  listeners = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    }
  ]
  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = var.tags
}
