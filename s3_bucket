terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }

   backend "s3" {
    bucket = "my-unique-bucket-name-${random_id.rand_id.hex}"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }

  
}

provider "aws" {
  region = "us-west-2"
}

resource "random_id" "rand_id" {
  byte_length = 8
  
}

resource "aws_s3_bucket" "my_bucket" {
    bucket = "my-unique-bucker-namae-${random_id.rand_id.hex}"  
}

resource "aws_s3_object" "my_object" {
    source =  "./awsterraform.txt"
    bucket = aws_s3_bucket.my_bucket.bucket
    key    = "awsterraform.txt"
}

output "rand_id" {
  value = random_id.rand_id.hex
  
}
