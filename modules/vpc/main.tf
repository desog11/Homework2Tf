data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "hw2-diego" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "hw2-${var.owner}"
  }
}

resource "aws_internet_gateway" "hw2-igw" {
  vpc_id = aws_vpc.hw2-diego.id

  tags = {
    Name = "hw2-${var.owner}"
  }
}

resource "aws_subnet" "subnets" {
  count                = var.no_subnets
  vpc_id               = aws_vpc.hw2-diego.id
  cidr_block           = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone_id = data.aws_availability_zones.available.zone_ids[count.index]

  tags = {
    Name    = count.index < 3  ? "hw2-public-subnet ${count.index}" : "hw2-private-subnet ${count.index}"
  }
}


#Public Route Table
resource "aws_route_table" "hw2-public-route-table" {
  vpc_id = aws_vpc.hw2-diego.id

  route {
    cidr_block = var.public_rt_cidr
    gateway_id = aws_internet_gateway.hw2-igw.id
  }

  tags = {
    Name = "hw2-public-route-table"
  }
}

#Association Public Route Table
resource "aws_route_table_association" "a-public-route-table" {
  count = var.no_subnets/2
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index)}"
  route_table_id = aws_route_table.hw2-public-route-table.id
}

#Elastic IP
resource "aws_eip" "hw2-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.hw2-igw]
  tags = {
    Name = "hw2-eip"
  }
}

# NAT GATEWAY

resource "aws_nat_gateway" "hw2-nat-gw" {
  allocation_id = aws_eip.hw2-eip.id 
  subnet_id     = "${element(aws_subnet.subnets.*.id, 5)}"
  tags = {
    Name = "hw2-nat-gw"
  }
}

#Private Route Table
resource "aws_route_table" "hw2-private-route-table" {
  vpc_id = aws_vpc.hw2-diego.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.hw2-nat-gw.id
  }
  tags = {
    Name = "hw2-private-route-table"
  }
}

#Association Private Route Table
resource "aws_route_table_association" "a-private-route-table" {
  count = var.no_subnets/2
  subnet_id      = "${element(aws_subnet.subnets.*.id, count.index+3)}"
  route_table_id = aws_route_table.hw2-private-route-table.id
}