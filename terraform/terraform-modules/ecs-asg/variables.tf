variable "name" {
  description = "The name of the ECS cluster"
}

variable "vpc_id" {
  description = "VPC id to create the ECS cluster, REQUIRED if not fargate"
  default     = ""
}

variable "predefined_metric_type" {
  description = "metric on which ecs cluster will scale"
  default     = "ASGAverageCPUUtilization"
}

variable "target_value" {
  description = "the target value for auto scaling"
  default     = 75.0
}

variable "ami" {
  description = "ECS AMI name, you can get the [latest optimized AMI here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html)"
  default     = "amzn-ami-2018.03.h-amazon-ecs-optimized"
}

variable "subnets" {
  description = "Subnets to create the ECS cluster, REQUIRED if not fargate"
  type        = "list"
  default     = []
}

variable "instance_type" {
  description = "Instance type to use for the ECS cluster"
  default     = "t2.medium"
}

variable "max_size" {
  description = "Maximum size of the ECS cluster"
  default     = "1"
}

variable "min_size" {
  description = "Minimum size of the ECS cluster"
  default     = "1"
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  default     = "300"
}

variable "health_check_type" {
  description = "The type of health check of the service, can be either EC2 or ELB"
  default     = "EC2"
}

variable "key_name" {
  description = "The key name to associate with the ecs cluster"
  default     = ""
}

variable "root_volume_size" {
  description = "Volume size of the instances in the ecs cluster"
  default     = "20"
}

variable "ebs_volume_size" {
  description = "Volume size of the instances in the ecs cluster"
  default     = "20"
}

variable "policy" {
  description = "IAM policy document to attach to the ecs cluster if specified"
  default     = ""
}

variable "cidr" {
  description = "List of CIDR to allow"
  type        = "list"
  default     = []
}

variable "security_groups" {
  description = "Stringified comma-spearated list of security groups to allow e.g `sg-12345,sg-274664`"
  default     = ""
}

variable "retention_in_days" {
  description = "Number of days to retain cloudwatch logs"
  default     = "30"
}

variable "tags" {
  description = "List of maps of tags to add"
  type        = "map"
  default     = {}
}

variable "autoscaling_tags" {
  description = "List of maps of autoscaling tags to add in format {key='key',value='value',propagate_at_launch=true}"
  type        = "list"
  default     = []
}

variable "estimated_instance_warmup" {
  description = "how long instance need to warm up after scaling"
  default     = "300"
}

variable "email" {
  description = "email to recieve notifications"
  default     = "default value"
}

variable "enable_scaling_notifications" {
  type        = "string"
  description = "enable scaling notifications only for prod"
}

variable "ecs_cluster_sg_ingress" {
  default = []
}

###### VARIABLES FOR ASG AUTO SCALING ####
variable "scaling_adjustment_up" {
  default     = "1"
  description = "How many instances to scale up by when triggered"
}

variable "scaling_adjustment_down" {
  default     = "-1"
  description = "How many instances to scale down by when triggered"
}

variable "scaling_metric_name" {
  default     = "MemoryReservation"
  description = "Options: CPUReservation or MemoryReservation"
}

variable "adjustment_type" {
  default     = "ChangeInCapacity"
  description = "Options: ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity"
}

variable "policy_cooldown" {
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}

variable "evaluation_periods_scaleUp" {
  default     = "2"
  description = "The number of periods over which data is compared to the specified threshold."
}

variable "evaluation_periods_scaleDown" {
  default     = "10"
  description = "The number of periods over which data is compared to the specified threshold."
}

variable "alarm_period" {
  default     = "120"
  description = "The period in seconds over which the specified statistic is applied."
}

variable "alarm_threshold_up" {
  default     = "80"
  description = "The value against which the specified statistic is compared."
}

variable "alarm_threshold_down" {
  default     = "10"
  description = "The value against which the specified statistic is compared."
}

variable "alarm_actions_enabled" {
  default = true
}

variable "mem_res_alarm_threshold_up" {
  default = "80"
}

variable "mem_res_alarm_threshold_down" {
  default = "10"
}

variable "mem_uti_alarm_threshold_up" {
  default = "80"
}

variable "mem_uti_alarm_threshold_down" {
  default = "40"
}

variable "bb_token_param" {
  description = "parameter name for bit bucket token to clone repos "
  default     = "/infra/bb_token"
}

variable "user_data" {
  description = "user data"
  default     = "default"
}
