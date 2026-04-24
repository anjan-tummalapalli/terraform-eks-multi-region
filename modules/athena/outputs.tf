# -----------------------------------------------------------------------------
# File: modules/athena/outputs.tf
# Purpose:
#   Publishes output contract for module 'athena'.
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

output "workgroup_name" {
  description = "Athena workgroup name."
  value       = aws_athena_workgroup.this.name
}

output "workgroup_arn" {
  description = "Athena workgroup ARN."
  value       = aws_athena_workgroup.this.arn
}

output "database_name" {
  description = "Athena database name, or null when not created."
  # Ternary Purpose: Selects the "value" value by evaluating a condition and
  # choosing true/false branches explicitly.
  value = var.create_database ? aws_athena_database.this[0].name : null
}
