
resource "aws_launch_configuration" "as_conf" {
  name          = "asg_test_instance"
  image_id      = "ami-053b0d53c279acc90" //Ubuntu Server 20.04 LTS (HVM), SSD Volume Type // Amazon Machine Image e.g. [ami-053b0d53c279acc90]
  instance_type = "c5.large"
  key_name      = "lesson_7_ansible"
  security_groups = [aws_security_group.web-sg.id]
}

resource "aws_placement_group" "test_lesson_asg" {
  name     = "test_lesson_asg"
  strategy = "cluster"
}


resource "aws_autoscaling_group" "c6a_large" {
  name                      = "c6a-terraform-test"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 30
  health_check_type         = "EC2"
  force_delete              = true
  placement_group           = aws_placement_group.test_lesson_asg.id
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = [for each in data.aws_subnets.vpcsubnets.ids : each]

  initial_lifecycle_hook {
    name                 = "foobar"
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
  autoscaling_group_name = aws_autoscaling_group.c5_large.name
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