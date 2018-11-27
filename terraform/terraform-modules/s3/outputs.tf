output "name" {
  description = "The s3 bucket name"
  value       = "${element(concat(aws_s3_bucket.this.*.id, aws_s3_bucket.enc.*.id),0)}"
}

output "bucket_domain_name" {
  description = "The s3 Bucket domain name"
  value       = "${element(concat(aws_s3_bucket.this.*.bucket_domain_name, aws_s3_bucket.enc.*.bucket_domain_name),0)}"
}

output "bucket_arn" {
  description = "The s3 Bucket ARN"
  value       = "${element(concat(aws_s3_bucket.this.*.arn, aws_s3_bucket.enc.*.arn),0)}"
}

output "hosted_zone_id" {
  description = "The route53 zone id for the s3 bucket"
  value       = "${element(concat(aws_s3_bucket.this.*.hosted_zone_id, aws_s3_bucket.enc.*.hosted_zone_id),0)}"
}

output "website_domain" {
  description = "The s3 Bucket website domain if configured as a website"
  value       = "s3-website-${element(concat(aws_s3_bucket.this.*.region, aws_s3_bucket.enc.*.region),0)}.amazonaws.com"
}

output "website_endpoint" {
  description = "The s3 Bucket website endpoint if bucket is configured as a website"
  value       = "${element(concat(aws_s3_bucket.this.*.id, aws_s3_bucket.enc.*.id),0)}.s3-website-${element(concat(aws_s3_bucket.this.*.region, aws_s3_bucket.enc.*.region),0)}.amazonaws.com"
}
