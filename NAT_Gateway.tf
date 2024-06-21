resource "aws_eip" "elastic_ip" {
  count  = length(var.public_subnets)
  domain = "vpc"

  tags = {
    "Name" = "${var.cluster_name}-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.elastic_ip[count.index].id
  subnet_id     = aws_subnet.Public_Subnets[count.index].id

  tags = {
    "Name" = "${var.cluster_name}-nat-gw-${count.index}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Igw]
}

# Private route table
resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block     = var.nat_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "${var.cluster_name}clust-private-route-table-${count.index}"
  }
}

resource "aws_route_table_association" "private_subnets_rta" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.Private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

