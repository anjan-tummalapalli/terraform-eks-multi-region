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
