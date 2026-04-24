# -----------------------------------------------------------------------------
# File: modules/sns-topic/main.tf
# Purpose:
#   Implements resource orchestration for module 'sns-topic'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in
# variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

locals {
  # Local Purpose: Defines derived value "topic_name" once for reuse and
  # consistent logic across this file.
  # Ternary Purpose: Selects the "topic_name" value by evaluating a condition
  # and choosing true/false branches explicitly.
  topic_name = var.fifo_topic ? "${var.name}.fifo" : var.name
}

# Resource Purpose: Creates a Simple Notification Service (SNS) topic for
# publish/subscribe notifications (aws_sns_topic.this).
resource "aws_sns_topic" "this" {
  name       = local.topic_name
  fifo_topic = var.fifo_topic
  # Ternary Purpose: Selects the "content_based_deduplication" value by
  # evaluating a condition and choosing true/false branches explicitly.
  content_based_deduplication = (
    var.fifo_topic ? var.content_based_deduplication : null
  )
  kms_master_key_id = var.kms_master_key_id

  tags = var.tags
}

# Resource Purpose: Subscribes an endpoint to receive messages from a Simple
# Notification Service (SNS) topic (aws_sns_topic_subscription.this).
resource "aws_sns_topic_subscription" "this" {
  for_each = {
    for idx, sub in var.subscriptions : idx => sub
  }

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}
