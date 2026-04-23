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
  value       = var.create_alias ? aws_kms_alias.primary[0].name : null
}

output "all_alias_names" {
  description = "All alias names created for this key."
  value = concat(
    var.create_alias ? [aws_kms_alias.primary[0].name] : [],
    [for alias in aws_kms_alias.additional : alias.name]
  )
}
