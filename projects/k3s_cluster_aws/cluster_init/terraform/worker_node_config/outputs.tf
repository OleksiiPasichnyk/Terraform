output "k3s_workers_instance_private_ip" {
    value = data.aws_instances.asg_instances.private_ips
}