terraform {
  backend "s3" {
    bucket = "terraform-axa"
    key    = "service/ecs-infra/tfstate"
    region = "eu-west-1"
  }
}
