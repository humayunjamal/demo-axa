provider "aws" {
  version = "~> 1.35.0"
  region  = "${var.region}"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
