variable "name" {
  type        = "string"
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}

variable "enable_streams" {
  type        = "string"
  default     = "false"
  description = "Enable DynamoDB streams"
}

variable "stream_view_type" {
  type        = "string"
  default     = ""
  description = "When an item in the table is modified, what information is written to the stream"
}

variable "hash_key" {
  type        = "string"
  description = "DynamoDB table Hash Key"
}

variable "range_key" {
  type        = "string"
  description = "DynamoDB table Range Key"
  default     = ""
}

variable "global_secondary_index_map" {
  type        = "list"
  default     = []
  description = "Additional global secondary indexes in the form of a list of mapped values"
}

variable "read_capacity" {
  default = 5
}

variable "write_capacity" {
  default = 5
}
