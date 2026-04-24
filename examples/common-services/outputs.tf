# -----------------------------------------------------------------------------
# File: examples/common-services/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'common-services'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "bucket_arn" {
  value = module.app_bucket.bucket_arn
}

output "queue_arn" {
  value = module.app_queue.queue_arn
}

output "lambda_arn" {
  value = module.app_lambda.function_arn
}

output "rds_endpoint" {
  value = module.app_db.db_endpoint
}

output "alb_dns_name" {
  value = module.app_alb.alb_dns_name
}
