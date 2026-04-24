# -----------------------------------------------------------------------------
# File: modules/lambda/outputs.tf
# Purpose:
#   Publishes output contract for module 'lambda'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal
# resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

output "function_name" {
  description = "Lambda function name."
  value       = module.lambda_function.function_name
}

output "function_arn" {
  description = "Lambda function ARN."
  value       = module.lambda_function.function_arn
}

output "invoke_arn" {
  description = "Lambda invoke ARN."
  value       = module.lambda_function.invoke_arn
}
