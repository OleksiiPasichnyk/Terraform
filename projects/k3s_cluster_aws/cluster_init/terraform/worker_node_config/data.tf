data "aws_instances" "asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = "K3S Worker ASG"
  }
}

data "aws_vpc" "k3s_vpc" {
  tags = {
    Name = "K3s_VPC"
  }
}

data "aws_subnets" "k3s_private_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.k3s_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["K3s_Private_Subnet"]
  }
}

data "aws_security_group" "k3s_sg" {
  name = "k3s-sg"
}

data "aws_iam_instance_profile" "k3s_node_instance_profile" {
  name = "k3s_node_instance_profile"
}
