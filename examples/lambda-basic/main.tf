provider "aws" {
  region = var.region
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/handler.py"
  output_path = "${path.module}/build/lambda.zip"
}

module "lambda" {
  source = "../../modules/lambda"

  function_name         = var.function_name
  filename              = data.archive_file.lambda_zip.output_path
  handler               = var.handler
  runtime               = var.runtime
  timeout               = var.timeout
  memory_size           = var.memory_size
  log_retention_days    = var.log_retention_days
  environment_variables = var.environment_variables
  tags                  = var.tags
}
