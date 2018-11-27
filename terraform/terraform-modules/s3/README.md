Module example:

    module "foo" {
      source = "../../terraform-modules/s3"
      name   = "foo"
    }




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| encrypted_bucket | Option whether to enable default server side bucket encryption | string | `false` | no |
| kms_arn | KMS arn to use as default bucket encryption | string | `aws/s3` | no |
| name | Name of the s3 bucket | string | - | yes |
| policy | Bucket policy | string | `` | no |
| tags | A map of tags to add to all resources | map | `<map>` | no |
| website | A list of map of website attributes, Ref: https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#website | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_arn | The s3 Bucket ARN |
| bucket_domain_name | The s3 Bucket domain name |
| hosted_zone_id | The route53 zone id for the s3 bucket |
| name | The s3 bucket name |
| website_domain | The s3 Bucket website domain if configured as a website |
| website_endpoint | The s3 Bucket website endpoint if bucket is configured as a website |

