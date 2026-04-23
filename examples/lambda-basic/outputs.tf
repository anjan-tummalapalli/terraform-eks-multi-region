output "function_name" {
  description = "Lambda function name."
  value       = module.lambda.function_name
}

output "function_arn" {
  description = "Lambda function ARN."
  value       = module.lambda.function_arn
}

output "invoke_arn" {
  description = "Lambda invoke ARN."
  value       = module.lambda.invoke_arn
}
