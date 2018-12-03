#!/bin/bash -x

cd terraform/staging/
terraform init
terraform apply -auto-approve


cd service/ecs-infra

terraform init
terraform apply -auto-approve

cd ../ecs-demo-service

terraform init
terraform apply -auto-approve

cd ../ec2-jenkins

terraform init
terraform apply -auto-approve

