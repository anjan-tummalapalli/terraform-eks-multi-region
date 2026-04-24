# -----------------------------------------------------------------------------
# File: modules/dynamodb-table/main.tf
# Purpose:
#   Implements resource orchestration for module 'dynamodb-table'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

locals {
  attributes = concat(
    [{ name = var.hash_key, type = var.hash_key_type }],
    var.range_key != null ? [{ name = var.range_key, type = var.range_key_type }] : []
  )
}

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key

  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  dynamic "attribute" {
    for_each = local.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  tags = var.tags
}
