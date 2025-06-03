variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  description = "common tags for all"
  type        = map(string)
  default = {
    "Owner"   = "sachit.desai@intuitive.cloud"
    "Project" = "terraform"
  }
}

variable "subnet_config" {
  description = "values for subnets"
  type = map(object({
    availability_zone       = string
    cidr_block              = string
    map_public_ip_on_launch = string
  }))
  default = {
    "public-web-subnet-1" = {
      availability_zone       = "us-east-1a"
      cidr_block              = "10.0.1.0/24"
      map_public_ip_on_launch = "true"
    },
    "public-web-subnet-2" = {
      availability_zone       = "us-east-1b"
      cidr_block              = "10.0.2.0/24"
      map_public_ip_on_launch = "true"
    },
    "private-app-subnet-1" = {
      availability_zone       = "us-east-1a"
      cidr_block              = "10.0.3.0/24"
      map_public_ip_on_launch = "false"
    },
    "private-app-subnet-2" = {
      availability_zone       = "us-east-1b"
      cidr_block              = "10.0.4.0/24"
      map_public_ip_on_launch = "false"
    },
    "private-db-subnet-1" = {
      availability_zone       = "us-east-1a"
      cidr_block              = "10.0.5.0/24"
      map_public_ip_on_launch = "false"
    },
    "private-db-subnet-2" = {
      availability_zone       = "us-east-1b"
      cidr_block              = "10.0.6.0/24"
      map_public_ip_on_launch = "false"
    },

  }
}