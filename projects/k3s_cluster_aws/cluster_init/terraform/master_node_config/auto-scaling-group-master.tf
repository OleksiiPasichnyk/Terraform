resource "aws_autoscaling_group" "k3s_master_asg" {
  launch_template {
    id      = aws_launch_template.k3s_master.id
    version = "$Latest"
  }
  name = "K3S Master ASG"
  min_size            = 1
  max_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = [data.aws_subnets.k3s_public_subnet.ids[0]]
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  tag {
    key                 = "Name"
    value               = "K3s_Master"
    propagate_at_launch = true
  }

}