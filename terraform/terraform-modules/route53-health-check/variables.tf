variable "domain_name" {
}
variable "port_number" {
  default = 443
}
variable "type" {
  default = "HTTPS"
}
variable "resource_path" {
  default = "/health"
}
variable "regions" {
  default = ["ap-southeast-1", "us-east-1", "eu-west-1"]
}
variable "healthcheck_name" {
  default = "Example Health Check"
}
variable "measure_latency" {
	default = "false"
}