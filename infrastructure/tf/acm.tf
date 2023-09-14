resource "aws_acm_certificate" "wp-cert" {
    domain_name = "mjkli.com"
    validation_method = "DNS"

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "wp-cert-val" {
    certificate_arn = aws_acm_certificate.wp-cert.arn
    validation_record_fqdns = [ for record in aws_route53_record.wp_cert_record : record.fqdn]
}
