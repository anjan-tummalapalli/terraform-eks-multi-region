# -----------------------------------------------------------------------------
# File: modules/vpc/main.tf
# Purpose:
#   Implements resource orchestration for module 'vpc'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in
# variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever
# inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented
# reason to relax them.
#   - Update README and related examples whenever this file changes module
# interfaces.
# -----------------------------------------------------------------------------

# Data Purpose: Reads data source aws_availability_zones.available to fetch
# existing Amazon Web Services (AWS) context required by dependent expressions.
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Local Purpose: Defines derived value "azs" once for reuse and consistent
  # logic across this file.
  azs = (
    slice(
      data.aws_availability_zones.available.names,
      0,
      min(var.az_count, length(data.aws_availability_zones.available.names))
    )
  )
  # Local Purpose: Defines derived value "nat_gateway_count" once for reuse and
  # consistent logic across this file.
  # Ternary Purpose: Selects the "nat_gateway_count" value by evaluating a
  # condition and choosing true/false branches explicitly.
  nat_gateway_count = (
    var.enable_nat_gateway
    ? (var.nat_gateway_per_az ? length(var.public_subnet_cidrs) : 1)
    : 0
  )
}

# Resource Purpose: Creates a Virtual Private Cloud (VPC) as the primary
# network boundary (aws_vpc.this).
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.name}-vpc"
  })
}

# Resource Purpose: Creates and attaches an Internet Gateway to enable Virtual
# Private Cloud (VPC) internet routing (aws_internet_gateway.this).
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

# Resource Purpose: Creates a subnet within the Virtual Private Cloud (VPC)
# address space (aws_subnet.public).
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.azs[count.index % length(local.azs)]
  map_public_ip_on_launch = true

  tags = merge(var.tags, var.public_subnet_tags, {
    Name = "${var.name}-public-${count.index + 1}"
    Tier = "public"
  })
}

# Resource Purpose: Creates a subnet within the Virtual Private Cloud (VPC)
# address space (aws_subnet.private).
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index % length(local.azs)]

  tags = merge(var.tags, var.private_subnet_tags, {
    Name = "${var.name}-private-${count.index + 1}"
    Tier = "private"
  })
}

# Resource Purpose: Creates a route table that defines network routing rules
# (aws_route_table.public).
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt"
  })
}

# Resource Purpose: Associates a subnet with a route table
# (aws_route_table_association.public).
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Resource Purpose: Allocates an Elastic IP address for stable public
# addressing (aws_eip.nat).
resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip-${count.index + 1}"
  })
}

# Resource Purpose: Creates a Network Address Translation (NAT) Gateway to
# provide outbound internet access for private subnets (aws_nat_gateway.this).
resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  # Ternary Purpose: Selects the "subnet_id" value by evaluating a condition
  # and choosing true/false branches explicitly.
  subnet_id = (
    var.nat_gateway_per_az
    ? aws_subnet.public[count.index].id
    : aws_subnet.public[0].id
  )

  tags = merge(var.tags, {
    Name = "${var.name}-nat-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.this]
}

# Resource Purpose: Creates a route table that defines network routing rules
# (aws_route_table.private).
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-private-rt-${count.index + 1}"
  })
}

# Resource Purpose: Creates a route entry inside a route table
# (aws_route.private_default).
resource "aws_route" "private_default" {
  # Ternary Purpose: Selects the "count" value by evaluating a condition and
  # choosing true/false branches explicitly.
  count = var.enable_nat_gateway ? length(aws_route_table.private) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  # Ternary Purpose: Selects the "nat_gateway_id" value by evaluating a
  # condition and choosing true/false branches explicitly.
  nat_gateway_id = (
    aws_nat_gateway.this[
      var.nat_gateway_per_az ? count.index % length(aws_nat_gateway.this) : 0
    ].id
  )
}

# Resource Purpose: Associates a subnet with a route table
# (aws_route_table_association.private).
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
