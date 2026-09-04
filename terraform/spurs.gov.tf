resource "aws_route53_zone" "spurs_gov_zone" {
  name = "spurs.gov."

  tags = {
    Project = "dns"
    Service = "spurs.gov"
    Owner   = "US-SPURS"
  }
}

# GitHub Pages apex IPv4 endpoints.
resource "aws_route53_record" "spurs_gov_apex_a" {
  zone_id = aws_route53_zone.spurs_gov_zone.zone_id
  name    = "spurs.gov."
  type    = "A"
  ttl     = 300
  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}

# GitHub Pages apex IPv6 endpoints.
resource "aws_route53_record" "spurs_gov_apex_aaaa" {
  zone_id = aws_route53_zone.spurs_gov_zone.zone_id
  name    = "spurs.gov."
  type    = "AAAA"
  ttl     = 300
  records = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153",
  ]
}

# Stable canonical hostname recommended by GitHub Pages. GitHub redirects
# between the configured apex custom domain and www when both are present.
resource "aws_route53_record" "spurs_gov_www_cname" {
  zone_id = aws_route53_zone.spurs_gov_zone.zone_id
  name    = "www.spurs.gov."
  type    = "CNAME"
  ttl     = 300
  records = ["us-spurs.github.io."]
}

# GitHub Pages provisions HTTPS through Let's Encrypt for correctly
# configured custom domains. Keep CAA explicit so certificate issuance is
# allowed without opening the zone to unrelated certificate authorities.
resource "aws_route53_record" "spurs_gov_caa" {
  zone_id = aws_route53_zone.spurs_gov_zone.zone_id
  name    = "spurs.gov."
  type    = "CAA"
  ttl     = 300
  records = ["0 issue \"letsencrypt.org\""]
}

output "spurs_gov_ns" {
  description = "Authoritative Route 53 name servers to delegate for spurs.gov in the .gov registrar."
  value       = aws_route53_zone.spurs_gov_zone.name_servers
}
