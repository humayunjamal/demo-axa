terraform {
  backend "s3" {
    bucket = "terraform-axa"
    key    = "service/ec2-jenkins/tfstate"
    region = "eu-west-1"
  }
}
