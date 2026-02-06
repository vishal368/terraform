terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.30.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  
}
  #Creating instance in ec2 automaticaty
resource "aws_instance" "example" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"   #Amazon AMI 2 ID
  vpc_security_group_ids = [aws_security_group.TF_SG.id]
  #first Key Pair Method
  key_name = "TF_Key"

  tags = {
    Name = "cham-instance"
  }
}


#Second Key Pair Method
resource "aws_key_pair" "TF_Key" {
  key_name   = "TF_Key"
  public_key = tls_private_key.rsa.public_key_openssh
}

#FOR ABOVE PUBLIC KEY 
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#TO CREATE A FOLDER TO STORE IN LOCALY on Sys
resource "local_file" "TF_Key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey.pem"
}

#Security groups using Terraform

resource "aws_security_group" "TF_SG" {
  name        = "tf-sg"
  description = "security group using Terraform"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "all-traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}
