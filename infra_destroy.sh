#!/bin/bash -x


cd terraform/staging/service/ec2-jenkins

terraform init
terraform destroy -auto-approve

cd ../ecs-demo-service

terraform init
terraform destroy -auto-approve


cd ../ecs-demo-service-uat

terraform init
terraform destroy -auto-approve

cd ../ecs-infra

terraform init
terraform destroy -auto-approve

cd ../../

terraform init
terraform destroy -auto-approve
