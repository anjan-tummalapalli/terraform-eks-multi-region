# -----------------------------------------------------------------------------
# File: examples/bedrock-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'bedrock-basic'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "bedrock_logging_configuration_id" {
  description = "Bedrock model invocation logging configuration ID."
  value       = module.bedrock.logging_configuration_id
}

output "bedrock_cloudwatch_log_group" {
  description = "CloudWatch log group name for Bedrock invocation logs."
  value       = module.bedrock.cloudwatch_log_group_name
}

output "bedrock_logging_role_arn" {
  description = "IAM role ARN used by Bedrock for logging delivery."
  value       = module.bedrock.logging_role_arn
}

output "bedrock_logs_bucket" {
  description = "S3 bucket name used for Bedrock logs."
  value       = module.bedrock_logs_bucket.bucket_id
}
