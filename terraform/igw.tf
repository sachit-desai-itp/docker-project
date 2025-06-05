resource "aws_internet_gateway" "sachit_igw" {
  vpc_id = aws_vpc.sachit_vpc.id
  tags = merge({ "Name" = "sachit-igw" }, var.tags)
}