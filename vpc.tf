

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }   
  }  
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}

#private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "my-private-subnet"
  }
  
}

# public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "my-public-subnet"
  }
  
}

# internet gateway to allow communication between vpc and internet
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.vpc1.id
    tags = {
        Name = "my-internet-gateway"
    }
  
}

# route table for public subnet
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc1.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}

resource "aws_route_table_association" "public-sub" {
    route_table_id = aws_route_table.public_rt.id
    subnet_id      = aws_subnet.public_subnet.id
  
}

resource "aws_instance" "vpc_instance1" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

    tags = {
        Name = "vpc-ec2-instance"
    }
}
