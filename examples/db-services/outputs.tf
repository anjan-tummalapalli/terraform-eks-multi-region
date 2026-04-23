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
