
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