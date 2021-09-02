locals {
  private_subnet_cidrs = var.private_subnet_cidr

  public_subnet_cidrs = var.public_subnet_cidr

  availability_zones = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c",
  ]
}

resource "aws_subnet" "public" {
  count             = length(local.public_subnet_cidrs)
  vpc_id            = data.aws_vpc.eks.id
  cidr_block        = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    "Name"                                      = "${local.prefix}-public-${element(local.availability_zones, count.index)}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private" {
  count             = length(local.private_subnet_cidrs)
  vpc_id            = data.aws_vpc.eks.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    "Name"                                      = "${local.prefix}-private-${element(local.availability_zones, count.index)}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_eip" "eip_eks" {
  count = length(local.private_subnet_cidrs)
  vpc   = true
  tags = {
    Name = "${local.prefix}-eip-${element(local.availability_zones, count.index)}"
  }
}

resource "aws_nat_gateway" "nat_gateway_eks" {
  count         = length(local.private_subnet_cidrs)
  allocation_id = aws_eip.eip_eks.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]

  tags = {
    Name = "${local.prefix}-nat-gateway-${element(local.availability_zones, count.index)}"
  }
}

resource "aws_route_table" "private_rt" {
  count  = length(local.private_subnet_cidrs)
  vpc_id = data.aws_vpc.eks.id

  dynamic "route" {
    for_each = var.additional_private_routes
    content {
      cidr_block                = lookup(route.value, "cidr_block", null)
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      ipv6_cidr_block           = lookup(route.value, "ipv6_cidr_block", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_eks.*.id[count.index]
  }

  tags = {
    Name = "${local.prefix}-private-route-table-${element(local.availability_zones, count.index)}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  dynamic "route" {
    for_each = var.additional_public_routes
    content {
      cidr_block                = lookup(route.value, "cidr_block", null)
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      ipv6_cidr_block           = lookup(route.value, "ipv6_cidr_block", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = {
    Name = "${local.prefix}-public-route-table"
  }
}

resource "aws_route_table_association" "private_eks" {
  count          = length(local.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_rt.*.id, count.index)
}

resource "aws_route_table_association" "public_eks" {
  count          = length(local.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "gh_vpn" {
  name        = "${local.prefix}-gh-vpn"
  description = "Allow SSH traffic"
  vpc_id      = data.aws_vpc.eks.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.gh_vpn_whitelist
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.prefix}-gh-vpn"
  }
}