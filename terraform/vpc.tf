resource "aws_vpc" "sachit_vpc" {
  cidr_block           = var.vpc_cidr
  tags                 = merge({ "Name" = "sachit-vpc" }, var.tags)
  enable_dns_hostnames = true
  enable_dns_support   = true
}