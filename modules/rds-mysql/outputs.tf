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
