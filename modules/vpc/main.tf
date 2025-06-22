locals {
  module_name       = "tf-aws/vpc"
  module_version    = file("${path.module}/RELEASE")
  module_maintainer = "Cloud Softway"
  default_tags = {
    ModuleName       = local.module_name
    ModuleVersion    = local.module_version
    ModuleMaintainer = local.module_maintainer
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.default_tags, var.tags, {
    Name = var.vpc_name
  })
}

#internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags, var.tags, {
    Name = "${var.vpc_name}-internet-gateway"
  })
}

###################################
## Public Subnets Configurations ##
###################################

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index].cidr
  availability_zone       = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.public_subnets[count.index].map_public_ip_on_launch

  tags = merge(local.default_tags, var.tags, {
    Name = "${var.vpc_name}-public-subnet-${var.public_subnets[count.index].availability_zone}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.default_tags, var.tags, {
    Name = "${var.vpc_name}-public-route-table"
  })
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
