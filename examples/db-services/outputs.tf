# -----------------------------------------------------------------------------
# File: examples/db-services/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'db-services'.
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

output "mysql_endpoint" {
  description = "MySQL endpoint."
  value       = module.mysql.db_endpoint
}

output "dynamodb_table_name" {
  description = "DynamoDB table name."
  value       = module.dynamodb.table_name
}

output "redis_endpoint" {
  description = "Redis endpoint."
  value       = module.redis.endpoint
}

output "sns_topic_arn" {
  description = "SNS topic ARN."
  value       = module.alerts.topic_arn
}
