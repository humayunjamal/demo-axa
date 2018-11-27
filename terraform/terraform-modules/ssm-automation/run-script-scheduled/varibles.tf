variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"
  default     = {}
}

variable "document_name" {}

variable "description" {}

variable "runCommand" {}

variable "association_name" {}

variable "schedule_expression" {}

variable "targets_key" {}

variable "targets_values" {}
