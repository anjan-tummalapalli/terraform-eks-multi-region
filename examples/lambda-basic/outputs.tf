# -----------------------------------------------------------------------------
# File: examples/lambda-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'lambda-basic'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
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
  value       = module.lambda.function_name
}

output "function_arn" {
  description = "Lambda function ARN."
  value       = module.lambda.function_arn
}

output "invoke_arn" {
  description = "Lambda invoke ARN."
  value       = module.lambda.invoke_arn
}
