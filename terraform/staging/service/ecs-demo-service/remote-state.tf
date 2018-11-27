terraform {
  backend "s3" {
    bucket = "terraform-axa"
    key    = "service/ecs-promotion/tfstate"
    region = "eu-west-1"
  }
}
