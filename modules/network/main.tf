data "aws_availability_zones" "az" {}

locals {
  az_list = join(", ", aws_subnet.public_subnets[*].availability_zone)
}

locals {
  private_subnet_id = join(", ", aws_subnet.private_subnets[*].id)
}

resource "aws_vpc" "project"{
    cidr_block           = var.vpc_cidr
    instance_tenancy     = "default"
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Environment = "${var.env}"
        Project     = "${var.project}"
        Name        = "${var.project}-VPC-${var.env}"
    }    
}

resource "aws_internet_gateway" "project" {
    vpc_id = aws_vpc.project.id

    tags = {
        Environment = "${var.env}"
        Project     = "${var.project}"
        Name        = "${var.project}-internet_gw-${var.env}"
    }
}

#=====================       NAT     ========================#

resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs)
  vpc   = true

  tags = {
    Name        = "${var.project}-${var.env}-nat-gw-${count.index + 1}"
    Environment = "${var.env}_nat_gw"
    Project     = "${var.project}_nat_gw"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name        = "${var.project}-${var.env}-nat-gw-${count.index + 1}"
    Environment = "${var.env}_nat_gw"
    Project     = "${var.project}_nat_gw"
  }
}
#======================Public Subnet========================#

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.project.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                            = "${var.project}-public-subnet-${count.index + 1}"
    Environment                                     = "${var.env}-public-subnet-${count.index + 1}"
    Project                                         = "${var.project}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "project" {
  vpc_id = aws_vpc.project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project.id
  }

  tags = {
    Environment = "${var.env}"
    Project     = "${var.project}"
    Name        = "${var.project}-public-route-${var.env}"
  }
}

resource "aws_route_table_association" "rt_association" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.project.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

#======================Private Subnet========================#

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.project.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    Name                                            = "${var.project}-private-subnet-${count.index + 1}"
    Environment                                     = "${var.env}-private-subnet-${count.index + 1}"
    Project                                         = "${var.project}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "project_private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Environment = "${var.env}_private_rt"
    Project     = "${var.project}_private_rt"
    Name        = "${var.project}-private-route-${var.env}"
  }
}

resource "aws_route_table_association" "rt_association_private" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.project_private[count.index].id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}

