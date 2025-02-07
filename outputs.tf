output "website_endpoints" {
  value = var.enable_cert_validation ? [for idx in range(1) : aws_s3_bucket_website_configuration.main[idx].website_endpoint] : []
}

output "cloudfront_distribution_domains" {
  value = var.enable_cert_validation ? [for idx in range(1) : aws_cloudfront_distribution.website[idx].domain_name] : []
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
  description = "Name servers for the Route 53 zone - you'll need to update your domain registrar with these"
}

output "certificate_validation_instructions" {
  value = var.enable_cert_validation ? "Certificate validation will be done automatically through Route 53" : null
}
