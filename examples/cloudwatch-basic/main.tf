# -----------------------------------------------------------------------------
# File: examples/cloudwatch-basic/main.tf
# Purpose:
#   Demonstrates end-to-end usage for example 'cloudwatch-basic'.
# Why this file exists:
#   Provides a runnable reference for adoption, testing, and onboarding without changing module internals.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

provider "aws" {
  region = var.region
}

locals {
  # Local Purpose: Defines "subscriptions" derived value used to keep expressions centralized and easier to maintain.
  subscriptions = var.alert_email != "" ? [
    {
      protocol = "email"
      endpoint = var.alert_email
    }
  ] : []
}

module "alarm_topic" {
  source = "../../modules/sns-topic"

  name          = "${var.name_prefix}-cloudwatch-alerts"
  subscriptions = local.subscriptions
  tags          = var.tags
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  log_groups = [
    {
      name              = "/aws/app/${var.name_prefix}/application"
      retention_in_days = 14
    },
    {
      name              = "/aws/app/${var.name_prefix}/security"
      retention_in_days = 30
    }
  ]

  metric_alarms = [
    {
      alarm_name          = "${var.name_prefix}-custom-error-count"
      alarm_description   = "Triggers when custom error metric breaches threshold"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 2
      metric_name         = "ErrorCount"
      namespace           = "Custom/Application"
      period              = 60
      statistic           = "Sum"
      threshold           = 10
      treat_missing_data  = "notBreaching"
      alarm_actions       = [module.alarm_topic.topic_arn]
      ok_actions          = [module.alarm_topic.topic_arn]
    }
  ]

  tags = var.tags
}
