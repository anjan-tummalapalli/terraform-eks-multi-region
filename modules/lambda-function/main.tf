# -----------------------------------------------------------------------------
# File: modules/lambda-function/main.tf
# Purpose:
#   Implements resource orchestration for module 'lambda-function'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Resource Purpose: Manages aws_iam_role resource "this" for this module/example deployment intent.
resource "aws_iam_role" "this" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = var.tags
}

# Resource Purpose: Manages aws_iam_role_policy_attachment resource "basic_execution" for this module/example deployment intent.
resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Resource Purpose: Manages aws_cloudwatch_log_group resource "this" for this module/example deployment intent.
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# Resource Purpose: Manages aws_lambda_function resource "this" for this module/example deployment intent.
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  filename      = var.filename
  role          = aws_iam_role.this.arn
  handler       = var.handler
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size

  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = var.environment_variables
  }

  tags = var.tags

  depends_on = [aws_iam_role_policy_attachment.basic_execution, aws_cloudwatch_log_group.this]
}
