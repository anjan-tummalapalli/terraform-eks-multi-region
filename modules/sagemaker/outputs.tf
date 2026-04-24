# -----------------------------------------------------------------------------
# File: modules/sagemaker/outputs.tf
# Purpose:
#   Publishes output contract for module 'sagemaker'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "notebook_instance_name" {
  description = "SageMaker notebook instance name."
  value       = aws_sagemaker_notebook_instance.this.name
}

output "notebook_instance_arn" {
  description = "SageMaker notebook instance ARN."
  value       = aws_sagemaker_notebook_instance.this.arn
}

output "notebook_instance_url" {
  description = "SageMaker notebook URL."
  value       = aws_sagemaker_notebook_instance.this.url
}

output "execution_role_arn" {
  description = "Execution role ARN attached to notebook instance."
  value       = local.effective_role_arn
}

output "lifecycle_configuration_name" {
  description = "Lifecycle configuration name in use, or null when not configured."
  value       = local.lifecycle_config_name
}
