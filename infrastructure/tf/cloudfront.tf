resource "aws_cloudfront_distribution" "cf_dist" {

    enabled = true
    aliases = [ "wp.mjkli.com" ]

    origin {
      domain_name = aws_lb.app-lb.dns_name
      origin_id = "wp-origin"
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
        viewer_protocol_policy = "https-only"
        min_ttl = 0
        default_ttl = 0
        max_ttl = 0
        forwarded_values {
          query_string = true

          headers = [
            "Host",
            "CloudFront-Forwarded-Proto",
            "CloudFront-is-Desktop-Viewer",
            "CloudFront-is-Mobile-Viewer",
            "CloudFront-is-Tablet-Viewer"]

          cookies {
            forward = "all"
          }
        }
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