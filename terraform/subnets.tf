resource "aws_subnet" "sachit_subnets" {
  for_each                = var.subnet_config
  vpc_id                  = aws_vpc.sachit_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags                    = merge({ "Name" = "${each.key}" }, var.tags)
}