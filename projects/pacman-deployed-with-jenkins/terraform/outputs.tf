
output "web-address-nodejs" {
  value = aws_instance.nodejs-app.public_ip
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}