terraform {
  backend "s3" {
    bucket     = "terraform-axa"
    key        = "tfstate"
    region     = "eu-west-1"
  }
}
