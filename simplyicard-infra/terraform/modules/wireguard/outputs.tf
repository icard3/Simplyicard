output "wireguard_public_ip" {
  description = "Public IP address of WireGuard VPN server"
  value       = aws_eip.wireguard.public_ip
}

output "wireguard_server_id" {
  description = "EC2 instance ID of WireGuard server"
  value       = aws_instance.wireguard.id
}

output "connection_instructions" {
  description = "Instructions to retrieve client configurations"
  value       = <<-EOT
    
    
    Share.conf files
  EOT
}

output "wireguard_private_key" {
  description = "Private key for SSH access to WireGuard server"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}
