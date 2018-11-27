variable "cluster" {
  description = "The cluster name or ARN"
}

variable "desired_count" {
  description = "The desired count"
  default     = 1
}

variable "name" {}

variable "container_definitions" {}

variable "service_role_iam_policy" {}

variable "metric_name" {
  default = []
}

variable "metric_target_value" {
  default = []
}

variable "min_capacity" {
  default = 1
}

variable "max_capacity" {
  default = 1
}

variable "container_port" {
  description = "container port to expose"
  default     = 80
}

variable "port" {
  description = "port for target group"
}

variable "health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "health_check_grace_period_seconds" {
  default = "300"
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "health_check_interval" {
  default = 5
}

variable "health_check_timeout" {
  default = 2
}

variable "health_check_healthy_threshold" {
  default = 2
}

variable "health_check_unhealthy_threshold" {
  default = 2
}

variable "deregistration_delay" {
  default     = "30"
  description = "The default deregistration delay"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "cloudwatch_log_group_name" {
  description = "cloudwatch log group name for ecs service"
}

variable "retention_in_days" {
  description = "log group retention in days"
  default     = 7
}

variable "task_role_iam_policy" {}
