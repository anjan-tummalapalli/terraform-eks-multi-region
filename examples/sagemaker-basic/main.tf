# -----------------------------------------------------------------------------
# File: examples/sagemaker-basic/main.tf
# Purpose:
#   Demonstrates end-to-end usage for example 'sagemaker-basic'.
# Why this file exists:
#   Provides a runnable reference for adoption, testing, and onboarding without
# changing module internals.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

provider "aws" {
  region = var.region
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

# Resource Purpose: Creates a security group that controls network traffic
# boundaries (aws_security_group.notebook).
resource "aws_security_group" "notebook" {
  name        = "${var.name_prefix}-sagemaker-sg"
  description = "Restrictive security group for SageMaker notebook"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.notebook_ingress_cidrs
    description = "Allow HTTPS access to notebook"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sagemaker-sg"
  })
}

module "data_bucket" {
  source = "../../modules/s3"

  bucket_name               = var.notebook_data_bucket_name
  versioning_enabled        = false
  sse_algorithm             = "AES256"
  enforce_ssl_requests      = true
  enable_lifecycle_rule     = true
  lifecycle_expiration_days = 30
  tags                      = var.tags
}

module "sagemaker" {
  source = "../../modules/sagemaker"

  name                                      = "${var.name_prefix}-notebook"
  instance_type                             = var.instance_type
  volume_size                               = 5
  subnet_id                                 = module.vpc.private_subnet_ids[0]
  security_group_ids                        = [aws_security_group.notebook.id]
  direct_internet_access                    = "Disabled"
  root_access                               = "Disabled"
  create_execution_role                     = true
  minimum_instance_metadata_service_version = "2"
  allowed_s3_bucket_arns                    = [module.data_bucket.bucket_arn]
  create_lifecycle_configuration            = true
  lifecycle_on_start                        = <<-EOT
    #!/bin/bash
    set -eux
    timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "Notebook start hook executed on ${timestamp}" \
      >> /var/log/sagemaker-lifecycle.log
  EOT
  tags                                      = var.tags
}
