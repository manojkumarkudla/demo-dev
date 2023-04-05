resource "aws_vpc" "K8s-vpc2" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public-sub1" {
  vpc_id     = aws_vpc.K8s-vpc2.id
  cidr_block = var.cidr_public_sub1
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/elb"                      = "1"
}
}

resource "aws_subnet" "public-sub2" {
  vpc_id     = aws_vpc.K8s-vpc2.id
  cidr_block = var.cidr_public_sub2
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
     "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_subnet" "public-sub3" {
  vpc_id     = aws_vpc.K8s-vpc2.id
  cidr_block = var.cidr_public_sub3
  availability_zone = "eu-west-1c"
  map_public_ip_on_launch = true

  tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/elb"                      = "1"
  }
}

resource "aws_subnet" "private-sub1" {
  vpc_id     = aws_vpc.K8s-vpc2.id
  cidr_block = var.cidr_private_sub1
  availability_zone = "eu-west-1a"

  tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

resource "aws_subnet" "private-sub2" {
  vpc_id     = aws_vpc.K8s-vpc2.id
  cidr_block = var.cidr_private_sub2
   availability_zone = "eu-west-1b"
  tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

 resource "aws_subnet" "private-sub3" {
  vpc_id     = aws_vpc.K8s-vpc2.id
  cidr_block = var.cidr_private_sub3
   availability_zone = "eu-west-1c"

  tags = {
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}


# resource "aws_subnet" "data" {
#   for_each = var.cidr_data
#   vpc_id     = aws_vpc.lab_vpc.id
#   cidr_block = each.value
#   availability_zone = join("" , [var.aws_region, each.key])

#   tags = {
#     Name = join("", ["data-", each.key])
#   }
# }

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.K8s-vpc2.id

  tags = {
    Name = "internet_gateway"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}


resource "aws_nat_gateway" "lab_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-sub1.id

  tags = {
    Name = " NAT gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}