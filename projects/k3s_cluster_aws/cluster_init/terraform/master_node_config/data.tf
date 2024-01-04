data "aws_vpc" "k3s_vpc" {
  tags = {
    Name = "K3s_VPC"
  }
}

data "aws_security_group" "k3s_sg" {
  name = "k3s-sg"
}

data "aws_subnets" "k3s_public_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.k3s_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["K3s_Public_Subnet"]
  }
}

data "aws_instances" "asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = aws_autoscaling_group.k3s_master_asg.name
  }
}

data "aws_iam_instance_profile" "k3s_node_instance_profile" {
  name = "k3s_node_instance_profile"
}

