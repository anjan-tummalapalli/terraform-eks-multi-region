# -----------------------------------------------------------------------------
# File: modules/rds-postgres/outputs.tf
# Purpose:
#   Publishes output contract for module 'rds-postgres'.
# Why this file exists:
#   Exposes only the values consumers need, reducing coupling to internal resource implementation details.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

output "db_instance_id" {
  description = "RDS instance identifier."
  value       = aws_db_instance.this.id
}

output "db_endpoint" {
  description = "RDS endpoint."
  value       = aws_db_instance.this.endpoint
}

output "engine_version" {
  description = "Database engine version in use."
  value       = aws_db_instance.this.engine_version_actual
}

output "security_group_id" {
  description = "RDS security group ID."
  value       = aws_security_group.this.id
}
