module "lambda_function" {
  source = "../lambda-function"

  function_name         = var.function_name
  filename              = var.filename
  handler               = var.handler
  runtime               = var.runtime
  timeout               = var.timeout
  memory_size           = var.memory_size
  environment_variables = var.environment_variables
  log_retention_days    = var.log_retention_days
  tags                  = var.tags
}
