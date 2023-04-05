resource "aws_route_table" "internet_route_table" {
  vpc_id = aws_vpc.K8s-vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "internet-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.K8s-vpc2.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.lab_nat_gateway.id
  }

  tags = {
    Name = "nat-route-table"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id     = aws_subnet.public-sub1.id
  route_table_id = aws_route_table.internet_route_table.id
}

resource "aws_route_table_association" "public2" {
  subnet_id     = aws_subnet.public-sub2.id
  route_table_id = aws_route_table.internet_route_table.id
}

resource "aws_route_table_association" "public3" {
  subnet_id     = aws_subnet.public-sub3.id
  route_table_id = aws_route_table.internet_route_table.id
}
resource "aws_route_table_association" "private1"{
  subnet_id      = aws_subnet.private-sub1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private2"{
  subnet_id      = aws_subnet.private-sub2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private3"{
  subnet_id      = aws_subnet.private-sub3.id
  route_table_id = aws_route_table.private_route_table.id
}
# resource "aws_route_table_association" "data" {
#   for_each = aws_subnet.data
#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.nat_route_tbl.id
# }