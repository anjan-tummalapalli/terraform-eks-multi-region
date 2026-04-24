# -----------------------------------------------------------------------------
# File: examples/ec2-s3-vpc/main.tf
# Purpose:
#   Demonstrates end-to-end usage for example 'ec2-s3-vpc'.
# Why this file exists:
#   Provides a runnable reference for adoption, testing, and onboarding without changing module internals.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

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

module "s3" {
  source = "../../modules/s3"

  bucket_name               = var.bucket_name
  versioning_enabled        = true
  enable_lifecycle_rule     = true
  lifecycle_expiration_days = 90
  tags                      = var.tags
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
      cidr_blocks = var.ingress_cidrs
      description = "Allow SSH"
    }
  ]
  tags = var.tags
}
