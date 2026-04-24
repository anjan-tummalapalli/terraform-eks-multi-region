# -----------------------------------------------------------------------------
# File: modules/kms/outputs.tf
# Purpose:
#   Publishes output contract for module 'kms'.
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

output "key_id" {
  description = "KMS key ID."
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "KMS key ARN."
  value       = aws_kms_key.this.arn
}

output "primary_alias_name" {
  description = "Primary KMS alias name, or null when not created."
  # Ternary Purpose: Selects the "value" value by evaluating a condition and
  # choosing true/false branches explicitly.
  value = var.create_alias ? aws_kms_alias.primary[0].name : null
}

output "all_alias_names" {
  description = "All alias names created for this key."
  value = concat(
    # Ternary Purpose: Evaluates a condition inline to choose between two
    # expression branches.
    var.create_alias ? [aws_kms_alias.primary[0].name] : [],
    [for alias in aws_kms_alias.additional : alias.name]
  )
}
