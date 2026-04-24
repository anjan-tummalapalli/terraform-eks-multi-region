# -----------------------------------------------------------------------------
# File: modules/vpc/main.tf
# Purpose:
#   Implements resource orchestration for module 'vpc'.
# Why this file exists:
#   Keeps all service wiring in one place so the module contract in variables/outputs remains stable and predictable.
# Documentation and maintenance notes:
#   - Keep descriptions and validations aligned with real behavior whenever inputs change.
#   - Preserve secure and cost-aware defaults unless there is a documented reason to relax them.
#   - Update README and related examples whenever this file changes module interfaces.
# -----------------------------------------------------------------------------

# Data Purpose: Reads aws_availability_zones data source "available" to reference existing AWS metadata/resources required by this configuration.
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Local Purpose: Defines "azs" derived value used to keep expressions centralized and easier to maintain.
  azs = slice(data.aws_availability_zones.available.names, 0, min(var.az_count, length(data.aws_availability_zones.available.names)))
  # Local Purpose: Defines "nat_gateway_count" derived value used to keep expressions centralized and easier to maintain.
  nat_gateway_count = var.enable_nat_gateway ? (var.nat_gateway_per_az ? length(var.public_subnet_cidrs) : 1) : 0
}

# Resource Purpose: Manages aws_vpc resource "this" for this module/example deployment intent.
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.name}-vpc"
  })
}

# Resource Purpose: Manages aws_internet_gateway resource "this" for this module/example deployment intent.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

# Resource Purpose: Manages aws_subnet resource "public" for this module/example deployment intent.
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

# Resource Purpose: Manages aws_subnet resource "private" for this module/example deployment intent.
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

# Resource Purpose: Manages aws_route_table resource "public" for this module/example deployment intent.
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

# Resource Purpose: Manages aws_route_table_association resource "public" for this module/example deployment intent.
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Resource Purpose: Manages aws_eip resource "nat" for this module/example deployment intent.
resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-nat-eip-${count.index + 1}"
  })
}

# Resource Purpose: Manages aws_nat_gateway resource "this" for this module/example deployment intent.
resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.nat_gateway_per_az ? aws_subnet.public[count.index].id : aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "${var.name}-nat-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.this]
}

# Resource Purpose: Manages aws_route_table resource "private" for this module/example deployment intent.
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-private-rt-${count.index + 1}"
  })
}

# Resource Purpose: Manages aws_route resource "private_default" for this module/example deployment intent.
resource "aws_route" "private_default" {
  count = var.enable_nat_gateway ? length(aws_route_table.private) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[var.nat_gateway_per_az ? count.index % length(aws_nat_gateway.this) : 0].id
}

# Resource Purpose: Manages aws_route_table_association resource "private" for this module/example deployment intent.
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
