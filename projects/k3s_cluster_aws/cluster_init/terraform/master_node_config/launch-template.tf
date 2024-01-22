resource "aws_launch_template" "k3s_master" {
  name_prefix   = "k3s-master-"
  image_id      = "ami-053b0d53c279acc90" # Update with the correct AMI ID
  instance_type = "c6a.large"             # Update as necessary
  key_name      = "jenkins-ansible"       # Update with your SSH key name


  vpc_security_group_ids = [data.aws_security_group.k3s_sg.id]
  # user_data = base64encode(<<EOF
  #     #!/bin/bash
  #     # Install K3s server with predefined token
  #     curl -sfL https://get.k3s.io | sh -s - server --token u2Qw5PbXC887MMv85LeG
  #     EOF
  # )
  iam_instance_profile {
    name = data.aws_iam_instance_profile.k3s_node_instance_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "K3s_Master"
    }
  }
}
