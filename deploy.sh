#!/bin/bash -x

export AWS_DEFAULT_REGION=eu-west-1
AWS_ACCOUNT=418754825935

SERVICE_NAME=demo-service
IMAGE_NAME=demo-service
ECS_CLUSTER=Demo-Cluster

### Assume IAM Role for the Staging AWS Account ###
temp_role=$(aws sts assume-role --role-arn "arn:aws:iam::$AWS_ACCOUNT:role/Deployment-Role" --role-session-name AWSCLI-Session)
export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)



eval "$(aws ecr get-login --no-include-email --region eu-west-1)"


docker build -t ${AWS_ACCOUNT}.dkr.ecr.eu-west-1.amazonaws.com/demo-service:latest .

docker push ${AWS_ACCOUNT}.dkr.ecr.eu-west-1.amazonaws.com/demo-service:latest


ecs-deploy -c $ECS_CLUSTER -n $SERVICE_NAME -to latest -i $IMAGE_NAME -t 300 
