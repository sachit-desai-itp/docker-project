resource "aws_route_table" "sachit_public_rtb" {
  vpc_id = aws_vpc.sachit_vpc.id
  tags = merge({ "Name" = "public-rtb" }, var.tags)

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sachit_igw.id
  }
}

resource "aws_route_table" "sachit_app_rtb" {
  vpc_id = aws_vpc.sachit_vpc.id
  tags = merge({ "Name" = "app-rtb" }, var.tags)
}

resource "aws_route_table" "sachit_db_rtb" {
  vpc_id = aws_vpc.sachit_vpc.id
  tags = merge({ "Name" = "db-rtb" }, var.tags)
}

resource "aws_route_table_association" "public_association" {
  for_each = {
    for key, subnet in var.subnet_config :
    key => subnet
    if subnet.map_public_ip_on_launch == "true"
  }

  subnet_id      = aws_subnet.sachit_subnets[each.key].id
  route_table_id = aws_route_table.sachit_public_rtb.id
}

resource "aws_route_table_association" "app_association" {
  for_each = {
    for key, subnet in var.subnet_config :
    key => subnet
    if can(regex("app", key))
  }

  subnet_id      = aws_subnet.sachit_subnets[each.key].id
  route_table_id = aws_route_table.sachit_app_rtb.id
}

resource "aws_route_table_association" "db_association" {
  for_each = {
    for key, subnet in var.subnet_config :
    key => subnet
    if can(regex("db", key))
  }

  subnet_id      = aws_subnet.sachit_subnets[each.key].id
  route_table_id = aws_route_table.sachit_app_rtb.id
}