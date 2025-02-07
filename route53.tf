# Route 53 Zone
resource "aws_route53_zone" "main" {
  provider = aws.main
  name = "${var.website_name}"
}

# Route 53 Records for ACM validation
resource "aws_route53_record" "cert_validation" {
  provider = aws.main
  for_each = var.enable_cert_validation ? {
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
  zone_id         = aws_route53_zone.main.zone_id
}

resource "aws_route53_record" "main_a" {
  count    = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  zone_id  = aws_route53_zone.main.zone_id
  name     = "${var.website_name}"
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.website[0].domain_name
    zone_id                = aws_cloudfront_distribution.website[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_a" {
  count    = var.enable_cert_validation ? 1 : 0
  provider = aws.main
  zone_id  = aws_route53_zone.main.zone_id
  name     = "www.${var.website_name}"
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.website[0].domain_name
    zone_id                = aws_cloudfront_distribution.website[0].hosted_zone_id
    evaluate_target_health = false
  }
}
