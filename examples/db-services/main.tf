provider "aws" {
  region = var.region
}

locals {
  subscriptions = var.alert_email != "" ? [
    {
      protocol = "email"
      endpoint = var.alert_email
    }
  ] : []
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

module "mysql" {
  source = "../../modules/rds-mysql"

  name                = "${var.name_prefix}-mysql"
  db_name             = "appdb"
  username            = var.db_username
  password            = var.db_password
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  allowed_cidr_blocks = [var.vpc_cidr]
  multi_az            = false
  tags                = var.tags
}

module "dynamodb" {
  source = "../../modules/dynamodb-table"

  table_name                       = "${var.name_prefix}-kv"
  hash_key                         = "pk"
  hash_key_type                    = "S"
  billing_mode                     = "PAY_PER_REQUEST"
  ttl_enabled                      = true
  ttl_attribute_name               = "expires_at"
  point_in_time_recovery_enabled   = true
  tags                             = var.tags
}

module "redis" {
  source = "../../modules/elasticache-redis"

  name                = "${var.name_prefix}-cache"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  allowed_cidr_blocks = [var.vpc_cidr]
  node_type           = "cache.t4g.micro"
  num_cache_nodes     = 1
  tags                = var.tags
}

module "alerts" {
  source = "../../modules/sns-topic"

  name          = "${var.name_prefix}-alerts"
  subscriptions = local.subscriptions
  tags          = var.tags
}
