# -----------------------------------------------------------------------------
# File: modules/cloudwatch/main.tf
# Purpose:
#   Implements resource orchestration for module 'cloudwatch'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

locals {
  # Local Purpose: Defines derived value "log_groups_map" once for reuse and consistent logic across this file.
  log_groups_map = {
    for lg in var.log_groups :
    lg.name => lg
  }

  # Local Purpose: Defines derived value "metric_alarms_map" once for reuse and consistent logic across this file.
  metric_alarms_map = {
    for alarm in var.metric_alarms :
    alarm.alarm_name => alarm
  }
}

# Resource Purpose: Creates a CloudWatch Logs group with retention and optional encryption settings (aws_cloudwatch_log_group.this).
resource "aws_cloudwatch_log_group" "this" {
  for_each = local.log_groups_map

  name              = each.value.name
  retention_in_days = each.value.retention_in_days
  kms_key_id        = try(each.value.kms_key_id, null)

  tags = var.tags
}

# Resource Purpose: Creates a CloudWatch metric alarm for threshold-based monitoring and alerting (aws_cloudwatch_metric_alarm.this).
resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = local.metric_alarms_map

  alarm_name                = each.value.alarm_name
  alarm_description         = try(each.value.alarm_description, null)
  comparison_operator       = each.value.comparison_operator
  evaluation_periods        = each.value.evaluation_periods
  metric_name               = each.value.metric_name
  namespace                 = each.value.namespace
  period                    = each.value.period
  statistic                 = try(each.value.statistic, null)
  extended_statistic        = try(each.value.extended_statistic, null)
  threshold                 = each.value.threshold
  treat_missing_data        = try(each.value.treat_missing_data, "missing")
  datapoints_to_alarm       = try(each.value.datapoints_to_alarm, null)
  unit                      = try(each.value.unit, null)
  dimensions                = try(each.value.dimensions, {})
  alarm_actions             = try(each.value.alarm_actions, [])
  ok_actions                = try(each.value.ok_actions, [])
  insufficient_data_actions = try(each.value.insufficient_data_actions, [])

  tags = var.tags
}
