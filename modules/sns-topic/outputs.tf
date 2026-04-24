# -----------------------------------------------------------------------------
# File: modules/sns-topic/outputs.tf
# Purpose:
#   Publishes output contract for module 'sns-topic'.
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

output "topic_name" {
  description = "SNS topic name."
  value       = aws_sns_topic.this.name
}

output "topic_arn" {
  description = "SNS topic ARN."
  value       = aws_sns_topic.this.arn
}
