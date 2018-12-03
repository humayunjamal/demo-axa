terraform {
  backend "s3" {
    bucket = "terraform-axa"
    key    = "service/ecs-demo-service-uat/tfstate"
    region = "eu-west-1"
  }
}
