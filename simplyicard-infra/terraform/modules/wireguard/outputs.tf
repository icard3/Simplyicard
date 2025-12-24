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
    To get client configurations:
    1. Save the private key to 'wireguard.pem' and run: chmod 400 wireguard.pem
    2. SSH into the server: ssh -i wireguard.pem ubuntu@${aws_eip.wireguard.public_ip}
    3. Run: sudo cat /root/wg-client-*.conf
    
    Share these .conf files with members.
  EOT
}

output "wireguard_private_key" {
  description = "Private key for SSH access to WireGuard server"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}
