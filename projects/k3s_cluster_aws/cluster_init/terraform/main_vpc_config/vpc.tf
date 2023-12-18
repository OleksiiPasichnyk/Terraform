# Define the VPC
resource "aws_vpc" "k3s_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "K3s_VPC"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "k3s_igw" {
  vpc_id = aws_vpc.k3s_vpc.id

  tags = {
    Name = "K3s_IGW"
  }
}

# Define a Public Subnet
resource "aws_subnet" "k3s_public_subnet" {
  vpc_id                  = aws_vpc.k3s_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "K3s_Public_Subnet"
  }
}

# Define a Private Subnet
resource "aws_subnet" "k3s_private_subnet" {
  vpc_id     = aws_vpc.k3s_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "K3s_Private_Subnet"
  }
}

# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "k3s_nat_eip" {
  vpc = true
}

# Create a NAT Gateway
resource "aws_nat_gateway" "k3s_nat_gateway" {
  allocation_id = aws_eip.k3s_nat_eip.id
  subnet_id     = aws_subnet.k3s_public_subnet.id

  tags = {
    Name = "K3s_NAT_Gateway"
  }
}

# Create a VPC Peering Connection
resource "aws_vpc_peering_connection" "k3s_vpc_peering" {
  peer_vpc_id = data.aws_vpc.default.id
  vpc_id      = aws_vpc.k3s_vpc.id
  auto_accept = true

  tags = {
    Name = "K3s_VPC_Peering"
  }
}

# Create a Combined Route Table for Public and Private Subnets
resource "aws_route_table" "k3s_combined_route_table" {
  vpc_id = aws_vpc.k3s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k3s_igw.id
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.k3s_nat_gateway.id
  }

  route {
    cidr_block                = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.k3s_vpc_peering.id
  }

  tags = {
    Name = "K3s_Combined_Route_Table"
  }
}

# Associate the Combined Route Table with the Public Subnet
resource "aws_route_table_association" "k3s_public_subnet_association" {
  subnet_id      = aws_subnet.k3s_public_subnet.id
  route_table_id = aws_route_table.k3s_combined_route_table.id
}

# Associate the Combined Route Table with the Private Subnet
resource "aws_route_table_association" "k3s_private_subnet_association" {
  subnet_id      = aws_subnet.k3s_private_subnet.id
  route_table_id = aws_route_table.k3s_combined_route_table.id
}