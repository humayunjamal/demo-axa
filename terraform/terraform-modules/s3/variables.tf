variable "name" {
  description = "Name of the s3 bucket"
}

variable "policy" {
  description = "Bucket policy"
  default     = ""
}

variable "encrypted_bucket" {
  description = "Option whether to enable default server side bucket encryption"
  default     = false
}

variable "kms_arn" {
  description = "KMS arn to use as default bucket encryption"
  default     = "aws/s3"
}

variable "website" {
  description = "A list of map of website attributes, Ref: https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#website"
  type        = "list"
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = "map"
  default     = {}
}

variable "versioning_enabled" {
  description = "enable versioning "
  default     = false
}
