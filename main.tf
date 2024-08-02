# Data Source Configuration for Availability Zones.
data "aws_availability_zones" "available_zones" {}

# Creating a Virtual Private Cloud (VPC).
resource "aws_vpc" "VPC" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.env}-${var.vpc_name}"
    Environment = "${var.env}"
  }

}

# Creating Internet Gateway and attaching it to the VPC.
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name        = "EKS-${var.env}-Internet-Gateway"
    Environment = "${var.env}"
  }
}

# Creating a route table and adding a route to the internet gateway.
resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = var.public_route_table_cidr_block
    gateway_id = aws_internet_gateway.Igw.id
  }

  tags = {
    Name        = "EKS-${var.env}-Route-Table"
    Environment = "${var.env}"
  }
}

# Creating public subnets.
resource "aws_subnet" "Public_Subnets" {
  map_public_ip_on_launch = true
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.VPC.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index % length(data.aws_availability_zones.available_zones.names)]

  tags = {
    Name        = "EKS-${var.env}-Public-Subnet-${count.index}"
    Environment = "${var.env}"
  }
}

# Attaching public route table with public subnets.
resource "aws_route_table_association" "Public_Route_Table_Association" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.Public_Subnets[count.index].id
  route_table_id = aws_route_table.Public_Route_Table.id
}

# Creating private subnets.
resource "aws_subnet" "Private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available_zones.names[count.index % length(data.aws_availability_zones.available_zones.names)]

  tags = {
    Name        = "EKS-${var.env}-Private-subnet-${count.index}"
    Environment = "${var.env}"
  }
}

# # Attaching route table with private subnets.
# resource "aws_route_table_association" "Private_Route_Table_Association" {
#   count          = length(var.private_subnets)
#   subnet_id      = aws_subnet.Private_subnets[count.index].id
#   route_table_id = aws_route_table.Public_Route_Table.id
# }

resource "aws_security_group" "EKS_Security_Group" {
  name   = var.security_group_name
  vpc_id = aws_vpc.VPC.id

  ingress {
    from_port   = var.https_ports
    to_port     = var.https_ports
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # New ingress rule for port 15017
  ingress {
    from_port   = 15017
    to_port     = 15017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # New ingress rule for port 15012
  ingress {
    from_port   = 15012
    to_port     = 15012
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS-Security-Group"
  }
}


