variable "alb_name" {
  default     = "default"
  description = "The name of the loadbalancer"
}

variable "tg_name" {
  description = "The name of the target group"
  default     = "default"
}

variable "aws_alb_target_group_port" {
  default = 80
}

variable "alb_protocols" {
  default = "HTTP"
}

variable "certificate_arn" {
  description = "The ARN of the SSL Certificate. e.g. arn:aws:iam::123456789012:server-certificate/ProdServerCert"
  default     = ""
}

variable "subnet_ids" {
  type        = "list"
  description = "List of subnet ids to place the loadbalancer in"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "allow_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify cird block that is allowd to acces the LoadBalancer"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "alb_internal" {
  default = "false"
}

variable "health_check_path" {
  default = "/"
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

variable "alb_sg_ingress" {
  default = []
}

variable "alb_sg_egress" {
  default = []
}

variable "load_balancer_arn" {
  description = "Load balancer ARN to be used with Target Groups"
  default     = ""
}

variable "access_logs_prefix" {
  default = ""
}

variable "access_logs_bucket" {
  default = ""
}
