output "cloudfront_dns" {
    value = aws_cloudfront_distribution.cf_dist.domain_name
}