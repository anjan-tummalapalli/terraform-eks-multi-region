# -----------------------------------------------------------------------------
# File: examples/lambda-basic/main.tf
# Purpose:
#   Demonstrates end-to-end usage for example 'lambda-basic'.
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

# Data Purpose: Reads data source archive_file.lambda_zip to fetch existing Amazon Web Services (AWS) context required by dependent expressions.
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
