data "aws_route53_zone" "mjkli_zone" {
    name = "mjkli.com"
    private_zone = false
}

resource "aws_route53_record" "wp" {
    zone_id = data.aws_route53_zone.mjkli_zone.zone_id
    name = "wp.${data.aws_route53_zone.mjkli_zone.name}"
    type = "CNAME"
    ttl = "300"
    records = [aws_lb.app-lb.dns_name]
}