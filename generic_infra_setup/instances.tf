
resource "aws_instance" "test_c6a_large_1" {
  ami                    = "ami-0a0c8eebcdd6dcbd0" # ubuntu arm64 
  # ami                  = "ami-053b0d53c279acc90" # Ubuntu amd64 (x86_64)
  instance_type          = "t4g.small"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  user_data              = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo bash -c 'cat > /var/www/html/index.html' <<EOF_HTML
    <!DOCTYPE html>
    <html>
    <head>
    <style>
      body {
        background-color: #A1B0FF;
        text-align: center;
      }
    </style>
    </head>
    <body>
      <h1>Hello, Team.</h1>
      <h1>Welcome to server 1!</h1>
    </body>
    </html>
    EOF_HTML
  EOF
  tags = {
    Name = "Test_1"
  }
}

resource "aws_instance" "test_c6a_large_2" {
  ami                    = "ami-053b0d53c279acc90" #Ubuntu
  instance_type          = "t4g.small"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name               = "lesson_7_ansible"
  user_data              = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo bash -c 'cat > /var/www/html/index.html' <<EOF_HTML
    <!DOCTYPE html>
    <html>
    <head>
    <style>
      body {
        background-color: #A1B0FF;
        text-align: center;
      }
    </style>
    </head>
    <body>
      <h1>Hello, Team.</h1>
      <h1>Welcome to server 2!</h1>
    </body>
    </html>
    EOF_HTML
  EOF
  tags = {
    Name = "Test_2"
  }
}
