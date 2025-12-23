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
    To get client configurations, SSH into the server:
    ssh ubuntu@${aws_eip.wireguard.public_ip}
    
    Then run:
    sudo cat /root/wg-client-*.conf
    
    Share these .conf files with your instructor and team members.
  EOT
}
