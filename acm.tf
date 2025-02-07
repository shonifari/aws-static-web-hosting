# ACM Certificate
resource "aws_acm_certificate" "cert" {
  count             = var.enable_cert_validation ? 1 : 0
  provider                  = aws.acm
  domain_name              = "www.${var.website_name}"
  subject_alternative_names = ["${var.website_name}"]
  validation_method        = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate validation
resource "aws_acm_certificate_validation" "cert" {
  count                   = var.enable_cert_validation ? 1 : 0

  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


