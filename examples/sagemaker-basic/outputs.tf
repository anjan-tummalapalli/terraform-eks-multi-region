# -----------------------------------------------------------------------------
# File: examples/sagemaker-basic/outputs.tf
# Purpose:
#   Exposes useful post-apply values for example 'sagemaker-basic'.
# Why this file exists:
#   Makes verification and operational handoff easier after provisioning.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "sagemaker_notebook_name" {
  description = "SageMaker notebook instance name."
  value       = module.sagemaker.notebook_instance_name
}

output "sagemaker_notebook_url" {
  description = "SageMaker notebook URL."
  value       = module.sagemaker.notebook_instance_url
}

output "sagemaker_execution_role_arn" {
  description = "IAM role ARN used by SageMaker notebook."
  value       = module.sagemaker.execution_role_arn
}

output "sagemaker_data_bucket" {
  description = "S3 bucket used for notebook data and artifacts."
  value       = module.data_bucket.bucket_id
}
