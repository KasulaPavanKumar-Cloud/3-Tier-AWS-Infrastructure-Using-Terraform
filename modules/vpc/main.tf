locals {
  public_map = { for idx, cidr in var.public_subnets : "public_${idx}" => cidr }
  app_map    = { for idx, cidr in var.private_app_subnets : "app_${idx}" => cidr }
  db_map     = { for idx, cidr in var.private_db_subnets : "db_${idx}" => cidr }
}


resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}Vpc_${var.owner}"
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.project}Igw_${var.owner}" }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}PublicSubnet_${count.index}_${var.owner}"
  }
}

resource "aws_subnet" "private_app" {
  count             = length(var.private_app_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project}AppSubnet_${count.index}_${var.owner}"
  }
}

resource "aws_subnet" "private_db" {
  count             = length(var.private_db_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_db_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project}DbSubnet_${count.index}_${var.owner}"
  }
}


resource "aws_eip" "nat" {
  tags = { Name = "${var.project}NatEip_${var.owner}" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags = { Name = "${var.project}Nat_${var.owner}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project}PublicRt_${var.owner}" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "${var.project}PrivateRt_${var.owner}" }
}

resource "aws_route_table_association" "public_assoc" {
  count     = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "app_assoc" {
  count          = length(aws_subnet.private_app)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_assoc" {
  count          = length(aws_subnet.private_db)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}

#just for testing purpose