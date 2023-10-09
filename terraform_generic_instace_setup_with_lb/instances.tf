
resource "aws_instance" "test_c6a_large_1" {
  ami                    = "ami-053b0d53c279acc90" #Ubuntu server 22.04
  instance_type          = "c6a.large" // do not forget to turn off the instance after the test ( 56$ per month)
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  tags = {
    Name = "Test_1"
  }
}

resource "aws_instance" "test_c6a_large_2" {
  ami                    = "ami-053b0d53c279acc90" #Ubuntu server 22.04
  instance_type          = "c6a.large" // do not forget to turn off the instance after the test ( 56$ per month)
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  tags = {
    Name = "Test_2"
  }
}
