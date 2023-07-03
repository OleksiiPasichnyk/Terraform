
output "web-address_test_instance_1" {
  value = aws_instance.test_c6a_large_1.public_dns
}

output "web-address_test_instance_2" {
  value = aws_instance.test_c6a_large_2.public_dns
}

output "web-address_lb" {
  value = aws_lb.my_test_front_end.dns_name
}

output "web-address_lb-zone-id-for-route53" {
  value = aws_lb.my_test_front_end.zone_id
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}