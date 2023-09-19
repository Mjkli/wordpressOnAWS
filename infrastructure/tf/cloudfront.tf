resource "random_string" "header_value" {
    length = 16
    special = true
}


resource "aws_cloudfront_distribution" "cf_dist" {

    enabled = true
    aliases = [ "wp.mjkli.com" ]

    origin {
      domain_name = aws_route53_record.wp-lb.fqdn
      origin_id = "wp-origin"
      
      custom_header {
        name = "X-Custom-Header"
        value = random_string.header_value.result
      }
      custom_origin_config {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols = ["TLSv1.2","TLSv1.1","TLSv1"]
      }
    }


    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD", "OPTIONS"]
        target_origin_id = "wp-origin"
        viewer_protocol_policy = "redirect-to-https"
        origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
        cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
        min_ttl = 0
        default_ttl = 0
        max_ttl = 0
    }

    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate_validation.wp-cert-val.certificate_arn
        minimum_protocol_version = "TLSv1"
        ssl_support_method = "sni-only"
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
            locations = []
        }
    }

}