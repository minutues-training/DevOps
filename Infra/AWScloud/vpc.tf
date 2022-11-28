#AWS-VPC Details
resource "aws_vpc" "virtualcloud" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "minutus-project"
  }
}

#Private Subnets Details
resource "aws_subnet" "subnets" {
  count                   = var.subnets
  vpc_id                  = aws_vpc.virtualcloud.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = var.ZONE1
  map_public_ip_on_launch = "false"
  tags = {
    Name = "Private-subnets${count.index}"
  }
}

#Public subnet of Apache web-server
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.virtualcloud.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = var.ZONE1
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public-subnet"
  }
}

#Alloting Elastic IP for natgateway
resource "aws_eip" "nat" {
  tags = {
    "Name" = "natip"
  }
}

#Natgateway to allow outbound communications from private subnets
resource "aws_nat_gateway" "natGW" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "NATgateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gateway]
}


#Internet gateway to access internet for both Private&Public subnets
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.virtualcloud.id

  tags = {
    Name = "IGW-for-VPC"
  }
}

#Creating route-table to go through internet gw and creating route
resource "aws_route_table" "Private-route" {
  vpc_id = aws_vpc.virtualcloud.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natGW.id
  }

  tags = {
    Name = "private-route"
  }

}
#Private-subnets route table 
resource "aws_route_table_association" "private-subnets" {
  count          = var.project-vm
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.Private-route.id
}

#Route table for Public subnet - Apache Web Server
resource "aws_route_table" "Public-route" {
  vpc_id = aws_vpc.virtualcloud.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "Public-route"
  }

}
#Route-table linking with public subnet
resource "aws_route_table_association" "public-subnets" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.Public-route.id
}

