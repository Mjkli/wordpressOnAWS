resource "aws_acm_certificate" "wp-cert" {
    provider = aws.virginia
    domain_name = "wp.mjkli.com"
    validation_method = "DNS"


    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "wp-cert-val" {
    provider = aws.virginia

    certificate_arn = aws_acm_certificate.wp-cert.arn
    validation_record_fqdns = [ for record in aws_route53_record.wp_cert_record : record.fqdn]
}

resource "aws_acm_certificate" "wp-lb-cert" {
    provider = aws.cali
    domain_name = "wp-lb.mjkli.com"
    validation_method = "DNS"


    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "wp-lb-cert-val" {
    provider = aws.cali
    certificate_arn = aws_acm_certificate.wp-cert.arn
    validation_record_fqdns = [ for record in aws_route53_record.wp_cert_record : record.fqdn]
}
