provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "neo_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Neo_VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "neo_igw" {
  vpc_id = aws_vpc.neo_vpc.id
  tags = {
    Name = "Neo-igw"
  }
}

# Route Table
resource "aws_route_table" "neo_route_table" {
  vpc_id = aws_vpc.neo_vpc.id
  tags = {
    Name = "Neo_routing_table"
  }

#   route {
#     cidr_block = "192.168.0.0/16"
#     gateway_id = "local"
#   }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.neo_igw.id
  }
}

# Subnet
resource "aws_subnet" "neo_subnet" {
  vpc_id                  = aws_vpc.neo_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "Neo_Subnet"
  }
}

# Associate Route Table
resource "aws_route_table_association" "route_assoc" {
  subnet_id      = aws_subnet.neo_subnet.id
  route_table_id = aws_route_table.neo_route_table.id
}

# Security Group
resource "aws_security_group" "neo_sg" {
  name        = "Neo_Technologies_sg"
  description = "Allow SSH, HTTP, HTTPS"
  vpc_id      = aws_vpc.neo_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "ghost" {
  ami                         = "ami-0faab6bdbac9486fb" # Ubuntu 22.04 in eu-central-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.neo_subnet.id
  vpc_security_group_ids      = [aws_security_group.neo_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = file("user_data.sh")

  tags = {
    Name = "GhostCMS"
  }
}
