# -----------------------------------------------------------------------------
# File: modules/sns-topic/main.tf
# Purpose:
#   Implements resource orchestration for module 'sns-topic'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

locals {
  # Local Purpose: Defines "topic_name" derived value used to keep expressions centralized and easier to maintain.
  topic_name = var.fifo_topic ? "${var.name}.fifo" : var.name
}

# Resource Purpose: Manages aws_sns_topic resource "this" for this module/example deployment intent.
resource "aws_sns_topic" "this" {
  name                        = local.topic_name
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : null
  kms_master_key_id           = var.kms_master_key_id

  tags = var.tags
}

# Resource Purpose: Manages aws_sns_topic_subscription resource "this" for this module/example deployment intent.
resource "aws_sns_topic_subscription" "this" {
  for_each = {
    for idx, sub in var.subscriptions : idx => sub
  }

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}
