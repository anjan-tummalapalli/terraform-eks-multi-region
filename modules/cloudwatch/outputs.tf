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
  value       = [for alarm in aws_cloudwatch_metric_alarm.this : alarm.alarm_name]
}

output "metric_alarm_arns" {
  description = "Metric alarm ARNs created by this module."
  value       = [for alarm in aws_cloudwatch_metric_alarm.this : alarm.arn]
}
