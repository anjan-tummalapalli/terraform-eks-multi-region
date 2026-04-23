output "bucket_id" {
  description = "S3 bucket ID."
  value       = module.bucket.bucket_id
}

output "bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.bucket.bucket_arn
}
