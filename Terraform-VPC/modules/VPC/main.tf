#VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "My-VPC"
  }
}

#Subnets
resource "aws_subnet" "my_subnets" {
  count                   = length(var.subnet_vpc) #how much subnets have been mentioned in the list.
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_vpc[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_names[count.index]
  }
}


#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-IGW"
  }
}


#route table
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"   #to make it public
    gateway_id = aws_internet_gateway.igw.id
  }
  tags ={
    Name = "my rtb"
  }
}

#route table association

resource "aws_route_table_association" "rta" {
count = length(var.subnet_vpc)
  subnet_id      = aws_subnet.my_subnets[count.index].id
  route_table_id = aws_route_table.rtb.id
}