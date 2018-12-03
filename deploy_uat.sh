#!/bin/bash -x

export AWS_DEFAULT_REGION=eu-west-1
AWS_ACCOUNT=418754825935

SERVICE_NAME=demo-service-uat
IMAGE_NAME=demo-service-uat
ECS_CLUSTER=Demo-Cluster


eval "$(aws ecr get-login --no-include-email --region eu-west-1)"


docker build -t ${AWS_ACCOUNT}.dkr.ecr.eu-west-1.amazonaws.com/demo-service-uat:latest .

docker push ${AWS_ACCOUNT}.dkr.ecr.eu-west-1.amazonaws.com/demo-service-uat:latest


ecs-deploy -c $ECS_CLUSTER -n $SERVICE_NAME -to latest -i $IMAGE_NAME -t 300 
