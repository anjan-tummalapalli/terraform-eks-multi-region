provider "aws" {
  region = var.region
}

locals {
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
