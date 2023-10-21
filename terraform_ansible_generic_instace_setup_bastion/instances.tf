resource "aws_instance" "bastion_1" {
  ami                    = "ami-053b0d53c279acc90" # Ubuntu server 22.04
  instance_type          = "t2.micro" # Do not forget to turn off the instance after the test (56$ per month)
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  iam_instance_profile   = "terraform_instance_access"

  tags = {
    Name = "Bastion_1"
  }
}
