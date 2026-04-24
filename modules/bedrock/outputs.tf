# -----------------------------------------------------------------------------
# File: modules/bedrock/outputs.tf
# Purpose:
#   Publishes output contract for module 'bedrock'.
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

output "logging_configuration_id" {
  description = "Bedrock model invocation logging configuration ID."
  value       = aws_bedrock_model_invocation_logging_configuration.this.id
}

output "cloudwatch_log_group_name" {
  description = <<-EOT
    CloudWatch log group used for Bedrock logging, or null when disabled.
  EOT
  # Ternary Purpose: Selects the "value" value by evaluating a condition and
  # choosing true/false branches explicitly.
  value = var.enable_cloudwatch_logging ? local.effective_log_group_name : null
}

output "logging_role_arn" {
  description = <<-EOT
    IAM role ARN used by Bedrock for log delivery, or null when CloudWatch
    logging is disabled.
  EOT
  value       = local.effective_role_arn
}
