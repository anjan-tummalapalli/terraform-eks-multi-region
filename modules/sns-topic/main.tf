locals {
  topic_name = var.fifo_topic ? "${var.name}.fifo" : var.name
}

resource "aws_sns_topic" "this" {
  name                        = local.topic_name
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : null
  kms_master_key_id           = var.kms_master_key_id

  tags = var.tags
}

resource "aws_sns_topic_subscription" "this" {
  for_each = {
    for idx, sub in var.subscriptions : idx => sub
  }

  topic_arn = aws_sns_topic.this.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}
