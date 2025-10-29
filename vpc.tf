resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags       = merge({ Name = local.vpc_name }, var.tags)
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ Name = local.igw_name }, var.tags)
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ Name = local.rt_name }, var.tags)
}


resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Create subnets and associations
resource "aws_subnet" "public" {
  for_each = { for s in var.public_subnets : s.suffix => s }


  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true


  tags = merge({ Name = "${var.prefix}-${each.value.suffix}" }, var.tags)
}


resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public


  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}