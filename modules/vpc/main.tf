# Create the VPC with DNS support so resources can resolve hostnames internally.
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

# Internet gateway for public subnet internet access.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "terraform-igw"
  }
}

# Route table that sends public subnet traffic to the internet gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}

# Public subnets for resources that need internet access.
resource "aws_subnet" "public" {
  for_each = local.public_subnet_map

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone_id    = element(data.aws_availability_zones.available.zone_ids, each.key)

  tags = {
    Name = "terraform-public-${each.key}"
  }
}

# Private subnets for RDS and other internal resources.
resource "aws_subnet" "private" {
  for_each = local.private_subnet_map

  vpc_id               = aws_vpc.this.id
  cidr_block           = each.value
  availability_zone_id = element(data.aws_availability_zones.available.zone_ids, each.key)

  tags = {
    Name = "terraform-private-${each.key}"
  }
}

# Associate public subnets with the public route table.
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Use only available AZs in the selected region.
data "aws_availability_zones" "available" {
  state = "available"
}
