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
