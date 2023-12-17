resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg"
  description = "Security group for K3s cluster"
  vpc_id      = aws_vpc.k3s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k3s_vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k3s_vpc.cidr_block] // Adjust this to match your VPC CIDR
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [aws_vpc.k3s_vpc.cidr_block] // Adjust this to match your VPC CIDR
  }
}
