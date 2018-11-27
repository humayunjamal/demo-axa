Module example:

    module "foo" {
      source  = "../terraform-modules/route53-record"
      zone_id = "AABBCC1122"
      name    = "a.foo.com"
      type    = "A"
      ttl     = "300"
      records = ["a.bar.com"]
    }

    module "foo" {
      source  = "../terraform-modules/route53-record"
      zone_id = "AABBCC1122"
      name    = "a.foo.com"
      type    = "A"
      create_alias      = true
      alias_domain_name = "a-bar.elb.amazonaws.com"
      alias_zone_id     = "XXYYZZ1122"
    }


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alias_domain_name | The alias domain name, REQUIRED if `var.create_alias` is enabled | string | `` | no |
| alias_zone_id | The alias zone id, REQUIRED if `var.create_alias` is enabled | string | `` | no |
| create_alias | Option whether to create alias | string | `false` | no |
| name | Name of the Route53 record | string | - | yes |
| records | A list of records to be added | string | `<list>` | no |
| ttl | Record TTL | string | `300` | no |
| type | Record type | string | `A` | no |
| zone_id | Id of the Route53 zone | string | - | yes |

