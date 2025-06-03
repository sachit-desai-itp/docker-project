resource "aws_internet_gateway" "sachit_igw" {
  tags      = merge({ "Name" = "sachit-igw" }, var.tags)
}

resource "aws_internet_gateway_attachment" "name" {
  internet_gateway_id = aws_internet_gateway.sachit_igw.id
  vpc_id = aws_vpc.sachit_vpc.id
}
