# The entire section create a certiface, public zone, and validate the certificate using DNS method

# Create the Route53 hosted zone
resource "aws_route53_zone" "toolingrazaq" {
  name = "toolingrazaq.com."
}

# Create the certificate using a wildcard for all the domains created in toolingrazaq.com
resource "aws_acm_certificate" "toolingrazaq" {
  domain_name       = "*.toolingrazaq.com"
  validation_method = "DNS"
}

# selecting validation method
resource "aws_route53_record" "toolingrazaq" {
  for_each = {
    for dvo in aws_acm_certificate.toolingrazaq.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.toolingrazaq.zone_id
}

# validate the certificate through DNS method
resource "aws_acm_certificate_validation" "toolingrazaq" {
  certificate_arn         = aws_acm_certificate.toolingrazaq.arn
  validation_record_fqdns = [for record in aws_route53_record.toolingrazaq : record.fqdn]
}

# create records for tooling
resource "aws_route53_record" "tooling" {
  zone_id = aws_route53_zone.toolingrazaq.zone_id
  name    = "tooling.toolingrazaq.com"
  type    = "A"

  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}

# create records for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = aws_route53_zone.toolingrazaq.zone_id
  name    = "wordpress.toolingrazaq.com"
  type    = "A"

  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}
