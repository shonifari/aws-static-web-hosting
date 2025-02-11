output "website_endpoints" {
  value =aws_s3_bucket_website_configuration.main.website_endpoint
}

output "cloudfront_distribution_domains" {
  value = var.enable_cert_validation ? [for idx in range(1) : aws_cloudfront_distribution.website[idx].domain_name] : []
}

output "name_servers" {
  value = var.enable_route53_zone ? aws_route53_zone.main[0].name_servers : []
  description = "Name servers for the Route 53 zone - you'll need to update your domain registrar with these"
}

output "certificate_validation_instructions" {
  value = var.enable_cert_validation ? "Certificate validation will be done automatically through Route 53" : null
}

output "cloudfront_distribution_id" {
  value = var.enable_cert_validation ? aws_cloudfront_distribution.website[0].id : null
}

output "bucket_name" {
  value = aws_s3_bucket.main.bucket
}
