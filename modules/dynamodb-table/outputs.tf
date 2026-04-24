# -----------------------------------------------------------------------------
# File: modules/dynamodb-table/outputs.tf
# Purpose:
#   Publishes output contract for module 'dynamodb-table'.
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

output "table_name" {
  description = "DynamoDB table name."
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "DynamoDB table ARN."
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "DynamoDB table ID."
  value       = aws_dynamodb_table.this.id
}
