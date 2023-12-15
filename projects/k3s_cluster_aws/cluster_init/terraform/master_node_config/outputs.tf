output "k3s_master_instance_private_ip" {
    value = data.aws_instances.asg_instances.private_ips[0]
}