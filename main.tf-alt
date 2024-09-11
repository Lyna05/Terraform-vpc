provider "aws" {
  region = "eu-central-1"
}

# VPC
resource "aws_vpc" "main_vpc_prod" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "main-prod-vpc"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw_prod" {
    vpc_id = aws_vpc.main_vpc_prod.id

    tags = {
        Name = "main-prod-igw"
    }
  
}

# Public subnet
resource "aws_subnet" "main_public_subnet_a_prod" {
    vpc_id = aws_vpc.main_vpc_prod.id
    cidr_block = "10.0.0.0/20"
    availability_zone = "eu-central-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "main-prod-public-subnet-a"
    }
  
}

# Private subnet
resource "aws_subnet" "main_private_subnet_a_prod" {
    vpc_id = aws_vpc.main_vpc_prod.id
    cidr_block = "10.0.128.0/20"
    availability_zone = "eu-central-1a"

    tags = {
        Name = "main-prod-private-subnet-a"
    }
  
}

# Public subnet
resource "aws_subnet" "main_public_subnet_b_prod" {
    vpc_id = aws_vpc.main_vpc_prod.id
    cidr_block = "10.0.16.0/20"
    availability_zone = "eu-central-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "main-prod-public-subnet-b"
    }
  
}

# Private subnet
resource "aws_subnet" "main_private_subnet_b_prod" {
    vpc_id = aws_vpc.main_vpc_prod.id
    cidr_block = "10.0.144.0/20"
    availability_zone = "eu-central-1b"

    tags = {
        Name = "main-prod-private-subnet-b"
    }
  
}

# Public Route Table
resource "aws_route_table" "public_rtb_prod" {
    vpc_id = aws_vpc.main_vpc_prod.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_igw_prod.id
    }

    tags = {
        Name = "main-prod-vpc-public-route-table"
    }
  
}

# Public Subnet to Public Route Table Association
resource "aws_route_table_association" "public_rtb_subnet_assoc_prod-a" {
    subnet_id = aws_subnet.main_public_subnet_a_prod.id
    route_table_id = aws_route_table.public_rtb_prod.id
}

resource "aws_route_table_association" "public_rtb_subnet_assoc_prod-b" {
    subnet_id = aws_subnet.main_public_subnet_b_prod.id
    route_table_id = aws_route_table.public_rtb_prod.id
}

# Security Group
resource "aws_security_group" "web_sg_prod" {
    vpc_id = aws_vpc.main_vpc_prod.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "web-security-group-prod"
    }
  
}

# EC2 Instance - Web Server
resource "aws_instance" "web_server_prod" {
    ami = "ami-0de02246788e4a354"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.main_public_subnet_a_prod.id
    vpc_security_group_ids = [ aws_security_group.web_sg_prod.id ]

    user_data = <<-EOF
                #!/bin/bash
                dnf update -y
                dnf install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "Hello World from $(hostname -f)!" > /var/www/html/index.html
                EOF

    tags = {
        Name = "web-server-prod"
    }
  
}

# Outputs

output "instance_public_ip" {
    description = "The public IP of the EC2 instance"
    value = aws_instance.web_server_prod.public_ip
}