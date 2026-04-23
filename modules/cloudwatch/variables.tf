variable "log_groups" {
  description = "CloudWatch log groups to create."
  type = list(object({
    name              = string
    retention_in_days = optional(number, 14)
    kms_key_id        = optional(string)
  }))
  default = []
}

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

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
