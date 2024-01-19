

data "aws_instances" "asg_instances" {
  instance_tags = {
    "aws:autoscaling:groupName" = "K3S Master ASG"
  }
}