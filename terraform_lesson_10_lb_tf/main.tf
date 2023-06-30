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
  required_version = ">= 1.3"
}


provider "aws" {
  region     = "us-east-1"
  access_key = var.key_id
  secret_key = var.key_value
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

resource "aws_instance" "test_c6a_large_1" {
  ami                    = "ami-053b0d53c279acc90" #Ubuntu
  instance_type          = "c6a.large"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  tags = {
    Name = "Test_1"
  }
}

resource "aws_instance" "test_c6a_large_2" {
  ami                    = "ami-053b0d53c279acc90" #Ubuntu
  instance_type          = "c6a.large"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  tags = {
    Name = "Test_2"
  }
}

resource "aws_lb" "my_test_front_end" {
  name                       = "test-lb-lesson-10"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = [for each in data.aws_subnets.vpcsubnets.ids : each]
  enable_deletion_protection = false
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "test-target-group"
  port     = 3000
  protocol = "TCP"
  vpc_id   = data.aws_vpc.main.id
  health_check {
    enabled             = true
    healthy_threshold   = 2
    port                = "3000"
    protocol            = "TCP"
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_test_front_end.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group_attachment" "test_1" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.test_c6a_large_1.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "test_2" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.test_c6a_large_2.id
  port             = 3000
}

data "aws_vpc" "main" {
  default = true
}

data "aws_subnets" "vpcsubnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "default-for-az"
    values = [true]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_subnet" "vpcsubnet" {
  for_each = { for index, subnetid in data.aws_subnets.vpcsubnets.ids : index => subnetid }
  id       = each.value
}


output "web-address_test_instance_1" {
  value = aws_instance.test_c6a_large_1.public_dns
}

output "web-address_test_instance_2" {
  value = aws_instance.test_c6a_large_2.public_dns
}

output "web-address_lb" {
  value = aws_lb.my_test_front_end.dns_name
}

output "web-address_lb-zone-id-for-route53" {
  value = aws_lb.my_test_front_end.zone_id
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}