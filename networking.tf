
locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {
  exclude_names =["eu-west-3c"]
}

resource "aws_vpc" "vpc" {
    cidr_block =  var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "ic_webapp"
    }

    # Because of IGW we need to create a new VPC attach it to IGW before destroy the old one
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public_rt"
  }
}

resource "aws_default_route_table" "private_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    Name = "private_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public_subnet" {
  count  = length(local.azs)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "public-${count.index + 1}"
  }
}

# because private subnet is associeted to default route table wich is private
resource "aws_route_table_association" "public_assoc" {
  count = length(local.azs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Always use ressource is prefer than inline declaration
resource "aws_security_group" "sg" {
  name        = "public_sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.access_ip, var.jenkins_ip]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}