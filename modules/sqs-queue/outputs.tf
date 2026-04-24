# -----------------------------------------------------------------------------
# File: modules/sqs-queue/outputs.tf
# Purpose:
#   Publishes output contract for module 'sqs-queue'.
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

output "queue_url" {
  description = "SQS queue URL."
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "SQS queue ARN."
  value       = aws_sqs_queue.this.arn
}
