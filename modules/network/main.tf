# AWS Virtual Private Network
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# AWS Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id
}

# AWS Subnets - Public
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "snet-public" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "${split(".", var.vpc_cidr)[0]}.${split(".", var.vpc_cidr)[1]}.${var.public_network_index + count.index}.0/24"
}

# Public route table
resource "aws_route_table" "pulic_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

# Association of Route Table to Subnets
resource "aws_route_table_association" "first_public_snet" {
  subnet_id      = element(aws_subnet.snet-public.*.id, count.index)
  route_table_id = aws_route_table.pulic_route_table.id
}

# Elastic IPs for NAT
resource "aws_eip" "elastic_ip" {
  vpc              = true
  public_ipv4_pool = "amazon"
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.snet-public[0].id
  depends_on = [
    aws_internet_gateway.main,
    aws_eip.elastic_ip,
    aws_subnet.snet-public[0]
  ]
}
