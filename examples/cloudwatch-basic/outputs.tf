# -----------------------------------------------------------------------------
# File: examples/cloudwatch-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'cloudwatch-basic'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "cloudwatch_log_group_names" {
  description = "Created CloudWatch log group names."
  value       = module.cloudwatch.log_group_names
}

output "cloudwatch_metric_alarm_names" {
  description = "Created CloudWatch metric alarm names."
  value       = module.cloudwatch.metric_alarm_names
}

output "alarm_topic_arn" {
  description = "SNS topic ARN used for alarm notifications."
  value       = module.alarm_topic.topic_arn
}
