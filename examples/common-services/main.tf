provider "aws" {
  region = var.region
}

locals {
  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

module "app_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name               = var.app_bucket_name
  versioning_enabled        = true
  enable_lifecycle_rule     = true
  lifecycle_expiration_days = 90
  tags                      = local.tags
}

module "app_queue" {
  source = "../../modules/sqs-queue"

  name = "example-app-queue"
  tags = local.tags
}

module "app_lambda" {
  source = "../../modules/lambda"

  function_name = "example-app-worker"
  filename      = "./lambda.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  environment_variables = {
    QUEUE_URL = module.app_queue.queue_url
  }
  tags = local.tags
}

module "app_db" {
  source = "../../modules/rds-postgres"

  name                = "example-app"
  db_name             = "appdb"
  username            = var.db_username
  password            = var.db_password
  vpc_id              = var.vpc_id
  subnet_ids          = var.private_subnet_ids
  allowed_cidr_blocks = ["10.0.0.0/8"]
  multi_az            = false
  tags                = local.tags
}

module "app_alb" {
  source = "../../modules/alb"

  name              = "example-app"
  vpc_id            = var.vpc_id
  subnet_ids        = var.public_subnet_ids
  listener_port     = 80
  target_port       = 8080
  health_check_path = "/health"
  tags              = local.tags
}
