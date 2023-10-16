resource "aws_launch_template" "as_conf" {
  name = "test_launch_template"
  image_id = "ami-053b0d53c279acc90"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "c6a.large"
  # key_name = "lesson_7_ansible"
  vpc_security_group_ids = [
    aws_security_group.web-sg.id
  ]
}


resource "aws_autoscaling_group" "c6a_large" {
  name                      = "c6a-terraform-test"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  force_delete              = true
  launch_template {
    id      = aws_launch_template.as_conf.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [for each in data.aws_subnets.vpcsubnets.ids : each]

  initial_lifecycle_hook {
    name                 = "test_lesson_asg"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 120
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

  }

  tag {
    key                 = "Name"
    value               = "ASG_TEST"
    propagate_at_launch = true
  }

  timeouts {
    delete = "2m"
  }
}

resource "aws_autoscaling_policy" "cpu_policy" {
  autoscaling_group_name = aws_autoscaling_group.c6a_large.name
  name                   = "cpu_bound"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }

}