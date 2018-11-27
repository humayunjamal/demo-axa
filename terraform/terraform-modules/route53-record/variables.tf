variable "name" {
  description = "Name of the Route53 record"
}

variable "zone_id" {
  description = "Id of the Route53 zone"
}

variable "type" {
  description = "Record type"
  default     = "A"
}

variable "ttl" {
  description = "Record TTL"
  default     = "300"
}

variable "create_alias" {
  description = "Option whether to create alias"
  default     = false
}

variable "alias_domain_name" {
  description = "The alias domain name, REQUIRED if `var.create_alias` is enabled"
  default     = ""
}

variable "alias_zone_id" {
  description = "The alias zone id, REQUIRED if `var.create_alias` is enabled"
  default     = ""
}

variable "records" {
  description = "A list of records to be added"
  default     = []
}
