# Terraform

## Prerequisite



* terraform binary
* boto3 pip module
* ansible pip module
* awscli pip module
> All these requirements have been packaged into the Dockerfile

## Documentation

Understanding of inputs and outputs of a module from a `README` file would ease the use of it.

This can be achieved by using [terraform-docs](https://github.com/segmentio/terraform-docs).

### Steps

* Download the [latest](https://github.com/segmentio/terraform-docs/releases) terraform-docs binary
* Change directory to module directory and generate the README.

```
cd terraform-modules/vpc
terraform-docs markdown . > README.md
```

* Follow the same step above for updating the documentation


## Local Development

### Secret Management with Parameter Store

[AWS Paramter Store](https://docs.aws.amazon.com/kms/latest/developerguide/services-parameter-store.html) with KMS is used manage sensitive data between applications or between terraform and ansible.

##### Usage

Make sure you follow the syntax of `/app/resource/parent/subparent/child` as the credential name e.g `ponkaservice/database/dbname/root/password`.

You can create a parameter by using the command 
```
aws ssm put-parameter --name /app/resource/parent/subparent/child --value "supersecretpassword1234" --type SecureString
```

You can use cli-input in case there is error *Error parsing parameter '--value'*
```
aws ssm put-parameter --cli-input-json '{
  "Name": "/alert/slack/url",
  "Value": "https://hooks.slack.com/services/1234567890/AAAAAA/AAAAAAAAAAAAAAA",
  "Type": "SecureString",
  "Overwrite": true
}'
```

You can read the stored parameter by using command

```
aws ssm get-parameter --name /app/resource/parent/subparent/child --with-decryption
```

You can get all the parameters by using command
```
aws ssm describe-parameters
aws ssm describe-parameters --with-decryption
```

You can get parameters by prefix (or path) by using command
```
aws ssm get-parameters-by-path --path /app --recursive
aws ssm get-parameters-by-path --path /app --recursive --with-decryption
```

##### Terraform Usage/Strategy/Structure for Fetchr

The directory structure is setup in a way that two different accounts can be managed using same terraform codebase. 


*staging*
*prod*
*terraform-modules*

staging/prod folder shall contain the terraform codebase for only the common AWS resources which will be used by other service specific resources for e.g VPC/IAM/Cloudwatch etc 

Further in there is a subfolder in staging/prod dir which is named as *service* , within this folder there should be terraform codebase as per service , for eg ecs-infra/ecs-service/proxy-structure etc 

The *terraform-modules* folder should have the terraform codebase that can be inherited in both staging/prod dir structure with minimilist adjusments , the idea is to have a common terraform codebase that is only seperated by vars values. 

##### Remote State for Terraform

The remote state for terraform for both accounts is being saved as per the directory structure. The bucket names for staging and prod are 

fetchr-staging-terraform (in staging account)
fetchr-prod-terraform (in prod account)

Both of the buckets are also created by terraform but tf local state is saved in the repo to maintain their state. 

Each account has a common remote state configured and a per service remote state which is defined inside the terraform codebase by the name remote-state.tf 

##### How do I create infra using Terraform ? 

* creating ALB service in staging
```
cd staging
(make sure alb terraform codebase is there to create the infra)
terraform init
terraform plan
terraform apply
```
