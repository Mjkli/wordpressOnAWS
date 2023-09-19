resource "aws_vpc" "wp-vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.wp-vpc.id

    tags = {
        Name = "wp-igw"
    }
}

resource "aws_subnet" "public-sub-1"{
    vpc_id = aws_vpc.wp-vpc.id
    availability_zone = "us-west-1a"
    cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "public-sub-2"{
    vpc_id = aws_vpc.wp-vpc.id
    availability_zone = "us-west-1b"
    cidr_block = "10.0.1.0/24"
}

resource "aws_route_table" "public-rt"{
    vpc_id = aws_vpc.wp-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "pub1-asso" {
    subnet_id = aws_subnet.public-sub-1.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "pub2-asso" {
    subnet_id = aws_subnet.public-sub-2.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_eip" "ngw-1-ip"{
    domain = "vpc"
}

resource "aws_eip" "ngw-2-ip"{
    domain = "vpc"
}

resource "aws_nat_gateway" "pub-sub-1-ngw"{
    allocation_id = aws_eip.ngw-1-ip.id
    subnet_id = aws_subnet.public-sub-1.id

    depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "pub-sub-2-ngw"{
    allocation_id = aws_eip.ngw-2-ip.id
    subnet_id = aws_subnet.public-sub-2.id

    depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "app-sub-1"{
    vpc_id = aws_vpc.wp-vpc.id
    availability_zone = "us-west-1a"
    cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "app-sub-2"{
    vpc_id = aws_vpc.wp-vpc.id
    availability_zone = "us-west-1b"
    cidr_block = "10.0.3.0/24"
}

resource "aws_route_table" "app-rt-1"{
    vpc_id = aws_vpc.wp-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.pub-sub-1-ngw.id
    }
}

resource "aws_route_table" "app-rt-2"{
    vpc_id = aws_vpc.wp-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.pub-sub-2-ngw.id
    }
}

resource "aws_route_table_association" "app1-asso" {
    subnet_id = aws_subnet.app-sub-1.id
    route_table_id = aws_route_table.app-rt-1.id
}

resource "aws_route_table_association" "app2-asso" {
    subnet_id = aws_subnet.app-sub-2.id
    route_table_id = aws_route_table.app-rt-2.id
}

resource "aws_subnet" "db-sub-1"{
    vpc_id = aws_vpc.wp-vpc.id
    availability_zone = "us-west-1a"
    cidr_block = "10.0.4.0/24"
}

resource "aws_subnet" "db-sub-2"{
    vpc_id = aws_vpc.wp-vpc.id
    availability_zone = "us-west-1b"
    cidr_block = "10.0.5.0/24"
}

resource "aws_route_table_association" "db1-asso" {
    subnet_id = aws_subnet.db-sub-1.id
    route_table_id = aws_route_table.app-rt-1.id
}

resource "aws_route_table_association" "db2-asso" {
    subnet_id = aws_subnet.db-sub-2.id
    route_table_id = aws_route_table.app-rt-1.id
}

resource "aws_lb" "app-lb"{
    name = "wp-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.allow_http.id]
    subnets = [aws_subnet.public-sub-1.id,aws_subnet.public-sub-2.id]
}

resource "aws_lb_target_group" "app-tg" {
    name = "wp-lb-tg"
    port = "80"
    protocol = "HTTP"
    vpc_id = aws_vpc.wp-vpc.id
}

resource "aws_lb_listener" "https_lb_listener" {
    load_balancer_arn = aws_lb.app-lb.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
    certificate_arn = aws_acm_certificate_validation.wp-lb-cert-val.certificate_arn

    default_action{
        type = "forward"
        target_group_arn = aws_lb_target_group.app-tg.arn
    }
}

resource "aws_lb_listener_rule" "listener_special_header" {
    listener_arn = aws_lb_listener.https_lb_listener.arn

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.app-tg.arn
    }
    condition {
      http_header {
        http_header_name = "X-Custom-Header"
        values = [ random_string.header_value.result ]
      }
    }
}

resource "aws_lb_listener" "http_lb_listener" {
    load_balancer_arn = aws_lb.app-lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "redirect"
      redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"

      }
    }

}
