resource "aws_cloudfront_distribution" "cf_dist" {

    enabled = true

    origin {
      domain_name = aws_lb.app-lb.dns_name
      origin_id = "wp-origin"
      custom_origin_config {
        http_port = 80
        https_port = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols = ["TLSv1.2","TLSv1.1","TLSv1"]
      }
    }


    default_cache_behavior {
        allowed_methods = ["GET","HEAD"]
        cached_methods = ["GET","HEAD"]
        target_origin_id = "wp-origin"
        cache_policy_id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
        origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
        viewer_protocol_policy = "https-only"
        min_ttl = 0
        default_ttl = 0
        max_ttl = 0
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
            locations = []
        }
    }

}