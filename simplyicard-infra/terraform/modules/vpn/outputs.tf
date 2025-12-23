output "vpn_endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.this.id
}

output "vpn_dns_name" {
  value = aws_ec2_client_vpn_endpoint.this.dns_name
}

output "client_cert_pem" {
  value = tls_locally_signed_cert.client.cert_pem
}

output "client_private_key_pem" {
  value     = tls_private_key.client.private_key_pem
  sensitive = true
}
