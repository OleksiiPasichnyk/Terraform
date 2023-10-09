terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }
  # backend "s3" {
  #   bucket     = "put your bucket name here"
  #   key        = "terraform_my_infra.tfstate"
  #   region     = "us-east-1"
  # }
  required_version = ">= 1.3"
}
provider "aws" {
  region     = "us-east-1"
}

#resource "tls_private_key" "test_key" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}
#
#resource "aws_key_pair" "generated_key" {
#  key_name   = "test_key"
#  public_key = tls_private_key.test_key.public_key_openssh
#}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 0
    to_port     = 65000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test" {
  ami                    = "ami-053b0d53c279acc90" // Ubuntu server 22.04
  instance_type          = "t2.micro" //instance type
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  # key_name               = "put your key name here"
  tags = {
    Name = "Test insta_Lesson_1_TF"
  }
}

output "web-address_test_instance_public_dns" {
  value = aws_instance.test.public_dns
}
output "web-address_test_instance_public_ip" {
  value = aws_instance.test.public_ip
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}