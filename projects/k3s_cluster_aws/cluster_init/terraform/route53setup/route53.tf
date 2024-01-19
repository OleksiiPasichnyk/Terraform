resource "aws_route53_zone" "my_zone" {
  name = "paxel.ca"
}

resource "aws_route53_record" "k3s-pacman" {
  zone_id = aws_route53_zone.my_zone.zone_id
  name    = "k3s-pacman-test.paxel.ca"  # The subdomain for the A record
  type    = "A"
  ttl     = "300"  # Time to live in seconds
  records = data.aws_instances.asg_instances.public_ips[0]
  depends_on = [ data.aws_instances.asg_instances ]
  }
