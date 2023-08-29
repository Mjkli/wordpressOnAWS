resource "aws_security_group" "allow_http"{
    name = "allow_80"
    description = "Allows public 80"
    vpc_id = aws_vpc.wp-vpc.id

    ingress {
        description = "TCP from public"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_http"
        project = "wp_on_AWS"
    }
}

resource "aws_security_group" "allow_lb" {
    name = "allow_from_alb"
    description = "allows http access from only the alb"
    vpc_id = aws_vpc.wp-vpc.id

    ingress {
        description = "HTTP from alb"
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["${aws_vpc.wp-vpc.cidr_block}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_lb"
        project = "wp_on_AWS"
    }

}