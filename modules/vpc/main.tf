resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = "cs_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = var.availability_zone[count.index]
  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "cs_ig"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    "Name" = "cs_rtb"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each       = { for k, v in aws_subnet.public_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rtb.id
}
