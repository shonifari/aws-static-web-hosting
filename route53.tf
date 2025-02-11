# Route 53 Zone
resource "aws_route53_zone" "main" {
  count    = var.enable_route53_zone ? 1 : 0

  name = "${var.website_name}"
}

# Route 53 Records for ACM validation
resource "aws_route53_record" "cert_validation" {

  
  for_each = (var.enable_route53_zone && var.enable_cert_validation) ? {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main[0].zone_id
}
 

resource "aws_route53_record" "main_a" {
  count    = var.enable_route53_zone ? 1 : 0
  
  zone_id  = aws_route53_zone.main[count.index].zone_id
  name     = "${var.website_name}"
  type     = "A"


  alias {
    name                   = (var.enable_route53_zone && var.enable_cert_validation) ? aws_cloudfront_distribution.website[0].domain_name : aws_s3_bucket_website_configuration.main.website_endpoint
    zone_id                = (var.enable_route53_zone && var.enable_cert_validation) ? aws_cloudfront_distribution.website[0].hosted_zone_id : aws_s3_bucket.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_a" {
  count    = var.enable_route53_zone ? 1 : 0
  
  zone_id  = aws_route53_zone.main[count.index].zone_id
  name     = "www.${var.website_name}"
  type     = "A"


  alias {
    name                   = (var.enable_route53_zone && var.enable_cert_validation) ? aws_cloudfront_distribution.website[0].domain_name : aws_s3_bucket_website_configuration.www.website_endpoint
    zone_id                = (var.enable_route53_zone && var.enable_cert_validation) ? aws_cloudfront_distribution.website[0].hosted_zone_id : aws_s3_bucket.www.hosted_zone_id
    evaluate_target_health = false

  }
}
