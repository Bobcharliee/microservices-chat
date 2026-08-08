# Create VPC
resource "aws_vpc" "microservices-vpc" {
  instance_tenancy = "default"
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true


  tags = {
    Name = "${var.project_name}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Create public and private subnets in az1
resource "aws_subnet" "ms-public-subnet-1a" {
  vpc_id     = aws_vpc.microservices-vpc.id
  cidr_block = var.pub_subnet_1a_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  region = var.aws_region

  tags = {
    Name = "${var.project_name}-public-subnet-az1"
  }
}

resource "aws_subnet" "ms-private-subnet-1a" {
  vpc_id     = aws_vpc.microservices-vpc.id
  cidr_block = var.priv_subnet_1a_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  region = var.aws_region

  tags = {
    Name = "${var.project_name}-private-subnet-az1"
  }
}

resource "aws_subnet" "ms-private-subnet-1b" {
  vpc_id     = aws_vpc.microservices-vpc.id
  cidr_block = var.priv_subnet_1b_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
  region = var.aws_region

  tags = {
    Name = "${var.project_name}-private-subnet-az1"
  }
}

# Create public and private subnets in az2
resource "aws_subnet" "ms-public-subnet-2a" {
  vpc_id     = aws_vpc.microservices-vpc.id
  cidr_block = var.pub_subnet_2a_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-az2"
  }
}

resource "aws_subnet" "ms-private-subnet-2a" {
  vpc_id     = aws_vpc.microservices-vpc.id
  cidr_block = var.priv_subnet_2a_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]
  region = var.aws_region

  tags = {
    Name = "${var.project_name}-private-subnet-az2"
  }
}

resource "aws_subnet" "ms-private-subnet-2b" {
  vpc_id     = aws_vpc.microservices-vpc.id
  cidr_block = var.priv_subnet_2b_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]
  region = var.aws_region

  tags = {
    Name = "${var.project_name}-private-subnet-az2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "ms-internet-gateway" {
  vpc_id = aws_vpc.microservices-vpc.id

  tags = {
    Name = "${var.project_name}-gateway"
  }
}

# Create a public route table
resource "aws_route_table" "ms-public-rt" {
  vpc_id = aws_vpc.microservices-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ms-internet-gateway.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Associate the public route table with the public subnet1
resource "aws_route_table_association" "ms-public-rt-assoc1" {
  subnet_id      = aws_subnet.ms-public-subnet-1a.id
  route_table_id = aws_route_table.ms-public-rt.id
}

# Associate the public route table with the public subnet2
resource "aws_route_table_association" "ms-public-rt-assoc2" {
  subnet_id      = aws_subnet.ms-public-subnet-2a.id
  route_table_id = aws_route_table.ms-public-rt.id
}

