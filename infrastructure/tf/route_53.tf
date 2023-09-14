data "aws_route53_zone" "mjkli_zone" {
    name = "mjkli.com"
    private_zone = false
}

resource "aws_route53_record" "wp" {
    for_each = {
        for dvo in aws_acm_certificate.wp-cert.domain_validation_options : dvo.domain_name => {
            name   = dvo.resource_record_name
            record = dvo.resource_record_value
            type   = dvo.resource_record_type
        }
  }

    zone_id = data.aws_route53_zone.mjkli_zone.zone_id
    name = each.value.name
    type = each.value.type
    ttl = "300"
    records = [each.value.record]
}