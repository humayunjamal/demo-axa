Module example:

    module "foo" {
      source = "../terraform-modules/sns"
      name   = "foo"
      email  = "me@example.com"
    }



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_topic | Create topic or only create subscription | string | `true` | no |
| email | SNS Topic Email | string | `` | no |
| email_protocol | SNS Topic Email Protocol | string | `email` | no |
| name | Name of the SNS topic | string | `` | no |
| sns_arn | SNS topic ARN | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| sns_topic | SNS topic ARN |

