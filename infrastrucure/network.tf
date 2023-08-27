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