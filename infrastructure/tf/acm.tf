resource "aws_acm_certificate" "wp-cert" {
    domain_name = aws_route53_record.wp.fqdn
    validation_method = "DNS"

    lifecycle {
      create_before_destroy = true
    }

}

# This associates the SSL cert with the ALB
resource "aws_lb_listener_certificate" "wp-cert-attach" {
    listener_arn = aws_lb_listener.lb_listener.arn
    certificate_arn = aws_acm_certificate.wp-cert.arn
}
