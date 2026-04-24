# -----------------------------------------------------------------------------
# File: modules/cloudwatch/outputs.tf
# Purpose:
#   Publishes output contract for module 'cloudwatch'.
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

output "log_group_names" {
  description = "Log group names created by this module."
  value       = [for lg in aws_cloudwatch_log_group.this : lg.name]
}

output "log_group_arns" {
  description = "Log group ARNs created by this module."
  value       = [for lg in aws_cloudwatch_log_group.this : lg.arn]
}

output "metric_alarm_names" {
  description = "Metric alarm names created by this module."
  value = (
    [for alarm in aws_cloudwatch_metric_alarm.this : alarm.alarm_name]
  )
}

output "metric_alarm_arns" {
  description = "Metric alarm ARNs created by this module."
  value       = [for alarm in aws_cloudwatch_metric_alarm.this : alarm.arn]
}
