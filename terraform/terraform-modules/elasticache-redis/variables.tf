variable "name" {
  description = "Elasticache cluster identifier name"
}

variable "create_subnet_group" {
  description = "Option whether to create elasticache subnet or not"
  default     = false
}

variable "subnet_name" {
  description = "Elasticache elasticache subnet name"
  default     = ""
}

variable "subnets" {
  description = "List of subnets to create the elasticache subnet group"
  type        = "list"
  default     = []
}

variable "vpc_id" {
  description = "VPC id to create the security group"
}

variable "azs" {
  description = "List of availability zones to create the cluster"
  type        = "list"
  default     = []
}

variable "family" {
  description = "The family of the ElastiCache parameter group"
  default     = "redis3.2"
}

variable "engine_version" {
  description = "Engine Version"
  default     = ""
}

variable "engine_version_default" {
  description = "Engine Version Default if `var.engine_version` is not specified"
  type        = "map"

  default = {
    "redis3.2" = "3.2.10"
  }
}

variable "port" {
  description = "Elasticache port"
  default     = "6379"
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes"
  default     = "cache.t2.micro"
}

variable "cluster_size" {
  description = "The number of cache nodes in the elaticache cluster"
  default     = "1"
}

variable "maintenance_window" {
  description = "Weekly time range during which system maintenance can occur, in UTC"
  type        = "string"
  default     = "fri:03:00-fri:04:00"
}

variable "backup_window" {
  description = "Daily time range during which the backups happen"
  type        = "string"
  default     = "02:00-02:30"
}

variable "retention_period" {
  description = "Number of days to retain backups for"
  type        = "string"
  default     = "0"
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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"
  default     = {}
}

variable "redis_sg_ingress" {
  default = []
}
