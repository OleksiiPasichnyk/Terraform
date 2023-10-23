
# Create IAM role for Jenkins
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_profile"
  role = aws_iam_role.jenkins_role.name
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "jenkins_role" {
  name = "jenkins_role"
  role = aws_iam_role.jenkins_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:*"
        ],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "s3:*"
        ],
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "iam:PassRole",
          "iam:ListRoles"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}
