# AWS Virtual Private Network
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# AWS Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main_vpc.id
}

# AWS Subnets
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)
}

# Routing table configuration for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

#  NAT gateways for private subnets communication with the outside world
resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]
}
# ElasticIP for private subnets communication with the outside world
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true
}

# Routing table configuration for private subnets
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "private" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
