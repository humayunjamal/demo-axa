variable "name" {
  description = "Name of the SNS topic"
  default     = ""
}

variable "create_topic" {
  description = "Create topic or only create subscription"
  default     = true
}

variable "sns_arn" {
  description = "SNS topic ARN"
  default     = ""
}

variable "email" {
  description = "SNS Topic Email"
  default     = false
}

variable "email_protocol" {
  description = "SNS Topic Email Protocol"
  default     = "email"
}
