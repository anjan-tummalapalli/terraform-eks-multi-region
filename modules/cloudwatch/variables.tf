# -----------------------------------------------------------------------------
# File: modules/cloudwatch/variables.tf
# Purpose:
#   Declares input interface for module 'cloudwatch' (types, defaults, validation).
# Why this file exists:
#   Acts as the module API boundary so callers can adopt upgrades safely with explicit input expectations.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Variable Purpose: Controls "log_groups" input behavior for this Terraform configuration interface.
variable "log_groups" {
  description = "CloudWatch log groups to create."
  type = list(object({
    name              = string
    retention_in_days = optional(number, 7)
    kms_key_id        = optional(string)
  }))
  default = []
}

# Variable Purpose: Controls "metric_alarms" input behavior for this Terraform configuration interface.
variable "metric_alarms" {
  description = "Metric alarms to create."
  type = list(object({
    alarm_name                = string
    alarm_description         = optional(string)
    comparison_operator       = string
    evaluation_periods        = number
    metric_name               = string
    namespace                 = string
    period                    = number
    statistic                 = optional(string)
    extended_statistic        = optional(string)
    threshold                 = number
    treat_missing_data        = optional(string, "missing")
    datapoints_to_alarm       = optional(number)
    unit                      = optional(string)
    dimensions                = optional(map(string), {})
    alarm_actions             = optional(list(string), [])
    ok_actions                = optional(list(string), [])
    insufficient_data_actions = optional(list(string), [])
  }))
  default = []
}

# Variable Purpose: Controls "tags" input behavior for this Terraform configuration interface.
variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
