
resource "aws_instance" "test_c6a_large_1" {
  ami                    = "ami-053b0d53c279acc90" #Ubuntu
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  user_data = <<-EOF
              #!/bin/bash
              sudo su
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo '<!DOCTYPE html>
<html>
<head>
<style>
  body {
    background-color: #A1B0FF; /* Replace with your desired background color */
  	text-align: center; /* Center-align text within the body */
  }
</style>
</head>
<body>
  <h1>Hello, Team.  </h1>
  <h1>Welcome to server 1!</h1>
</body>
</html>' > /var/www/html/index.html
              EOF

  tags = {
    Name = "Test_1"
  }
}

resource "aws_instance" "test_c6a_large_2" {
  ami                    = "ami-053b0d53c279acc90" #Ubuntu
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  user_data = <<-EOF
              #!/bin/bash
              sudo su
              apt-get update
              apt-get install -y apache2
              systemctl start apache2
              systemctl enable apache2
              echo '<!DOCTYPE html>
<html>
<head>
<style>
  body {
    background-color: #A1B0FF; /* Replace with your desired background color */
  	text-align: center; /* Center-align text within the body */
  }
</style>
</head>
<body>
  <h1>Hello, Team.  </h1>
  <h1>Welcome to server 2!</h1>
</body>
</html>' > /var/www/html/index.html
              EOF
  tags = {
    Name = "Test_2"
  }
}
