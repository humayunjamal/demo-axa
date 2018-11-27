variable "subnet_ids" {
  type        = "list"
  description = "List of subnet ids to place the loadbalancer in"
}

variable "name" {
  default     = "default"
  description = "The name of the loadbalancer"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "nlb_http_tg_name" {}
variable "nlb_https_tg_name" {}
