resource "aws_acm_certificate" "api" {
  domain_name       = "${var.ENVIRONMENT != "production" ? "${var.ENVIRONMENT}." : ""}${var.SUBDOMAIN}.${var.DOMAIN}"
  validation_method = "DNS"
}

# Get existing hosted zone id
data "aws_route53_zone" "domain" {
  name         = var.DOMAIN
  private_zone = false
}

resource "aws_route53_record" "api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id
}

resource "aws_acm_certificate_validation" "api" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api_validation : record.fqdn]
}