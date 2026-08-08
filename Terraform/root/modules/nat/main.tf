resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.pub_subnet_1a_id
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [aws_eip.nat_eip]
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.project_name}-private-rt"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_rt_assoc_1a" {
  subnet_id      = var.priv_subnet_1a_id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_1b" {
  subnet_id      = var.priv_subnet_1b_id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2a" {
  subnet_id      = var.priv_subnet_2a_id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2b" {
  subnet_id      = var.priv_subnet_2b_id
  route_table_id = aws_route_table.private_rt.id
}