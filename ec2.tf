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


#key pair for ec2 instance login: now generate the key via "ssh-keygen" and copy the public key directly or via argument key_name= "file("public_key.pub")"
resource "aws_key_pair" "my_terraform_key" {
  key_name   = "my-key-pair"
  public_key = file("public_key.pub")
}

#security group for ec2 instance

#use default vpc id
resource "aws_default_vpc" default {

}

#security group inbound and outbound rules
resource "aws_security_group" "my_sg" {
    name = "my-security-group"
    description = "Security group for my EC2 instance"
    vpc_id = aws_default_vpc.default.id #thid is known as interpolation


    #inbound rules
    ingress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all inbound traffic"
    }

    #outbound rules
    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound traffic"
    }


    tags = {
        Name = "my-security-group"
    }

  
}



##ec2 instance resource
resource "aws_instance" "my_ec2_instance" {
    
    #count = 1 # it defines how many instances to create and it is a meta-argument
    #for each is another meta-argument alternative to count when you want to create multiple resources with different configurations
    for_each = tomap({
        my-instance1 = "t2.micro"
        my-instance2 = "t3.micro"
    })
    ami = "ami-0c55b159cbfafe1f0" #amazon linux 2 AMI in us-west-2 region
    instance_type = each.value
    key_name = aws_key_pair.my_terraform_key.key_name
    security_groups = [aws_security_group.my_sg.name]

    root_block_device {
        volume_size = 8
        volume_type = "gp3"
    }

    tags = {
        Name = each.key
    }
  
}

