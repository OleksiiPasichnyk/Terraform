output "k3s_master_instance_private_ip" {
    value = data.aws_instances.asg_instances.private_ips[0]
}
output "k3s_master_instance_public_ip" {
    value = data.aws_instances.asg_instances.public_ips[0]
  
}