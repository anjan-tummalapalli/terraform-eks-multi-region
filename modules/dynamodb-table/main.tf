# -----------------------------------------------------------------------------
# File: modules/dynamodb-table/main.tf
# Purpose:
#   Implements resource orchestration for module 'dynamodb-table'.
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
  # Local Purpose: Defines derived value "attributes" once for reuse and
  # consistent logic across this file.
  attributes = concat(
    [{ name = var.hash_key, type = var.hash_key_type }],
    # Ternary Purpose: Evaluates a condition inline to choose between two
    # expression branches.
    var.range_key != null
    ? [{ name = var.range_key, type = var.range_key_type }]
    : []
  )
}

# Resource Purpose: Creates a DynamoDB table with key schema, billing mode, and
# recovery settings (aws_dynamodb_table.this).
resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key

  # Ternary Purpose: Selects the "read_capacity" value by evaluating a
  # condition and choosing true/false branches explicitly.
  read_capacity = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  # Ternary Purpose: Selects the "write_capacity" value by evaluating a
  # condition and choosing true/false branches explicitly.
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  # Dynamic Purpose: Expands table attribute schema blocks from
  # local.attributes for hash and optional range-key definitions.
  dynamic "attribute" {
    for_each = local.attributes
    content {
      name = attribute.value.name
      # DynamoDB attribute type codes: S = String, N = Number, B = Binary.
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
