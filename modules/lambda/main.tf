# -----------------------------------------------------------------------------
# File: modules/lambda/main.tf
# Purpose:
#   Implements resource orchestration for module 'lambda'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in
# variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

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
