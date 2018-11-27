data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "net" {
  id = "vpc-d3fed0b5"
}

data "aws_subnet_ids" "net_public" {
  vpc_id = "${data.aws_vpc.net.id}"

  tags {
    Network = "Public"
  }
}
