output "kms_key_arn" {
  description = "KMS key ARN used for encryption."
  value       = module.kms.key_arn
}

output "kms_aliases" {
  description = "Aliases created for KMS key."
  value       = module.kms.all_alias_names
}

output "s3_bucket_arn" {
  description = "Encrypted S3 bucket ARN."
  value       = module.secure_bucket.bucket_arn
}
