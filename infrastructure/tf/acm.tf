resource "aws_acm_certificate" "wp-cert" {
    provider = aws.virginia
    domain_name = "wp.mjkli.com"
    validation_method = "DNS"


    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "wp-cert-val" {
    certificate_arn = aws_acm_certificate.wp-cert.arn
    validation_record_fqdns = [ for record in aws_route53_record.wp_cert_record : record.fqdn]
}
