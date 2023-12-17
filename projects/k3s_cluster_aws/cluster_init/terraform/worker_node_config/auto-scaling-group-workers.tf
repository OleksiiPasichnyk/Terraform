resource "aws_autoscaling_group" "k3s_worker_asg" {
  launch_template {
    id      = aws_launch_template.k3s_worker.id
    version = "$Latest"
  }
  name = "K3S Worker ASG"
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [data.aws_subnets.k3s_private_subnet.ids[0]]
  health_check_type         = "EC2"
  health_check_grace_period = 300
  force_delete              = true
  tag {
    key                 = "Name"
    value               = "K3s_Worker"
    propagate_at_launch = true
  }
}
