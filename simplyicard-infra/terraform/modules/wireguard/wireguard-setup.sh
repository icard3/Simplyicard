#!/bin/bash
# Version 1.2 (Fix IP address)
set -e

# Redirect output to log file
exec > >(tee /var/log/wireguard-setup.log) 2>&1

echo "Starting WireGuard setup..."

# valid update command with retry
for i in {1..5}; do
  apt-get update && break || sleep 15
done

# Install WireGuard with retry
DEBIAN_FRONTEND=noninteractive apt-get install -y wireguard || {
  echo "Failed to install wireguard, retrying..."
  sleep 10
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y wireguard
}

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Detect default network interface
DEFAULT_IFACE=$(ip route show default | awk '/default/ {print $5}')
echo "Detected default interface: $DEFAULT_IFACE"

# Generate server keys
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
chmod 600 /etc/wireguard/server_private.key

SERVER_PRIVATE_KEY=$(cat /etc/wireguard/server_private.key)
SERVER_PUBLIC_KEY=$(cat /etc/wireguard/server_public.key)

# Create server configuration
# Extract network part and set Host IP to .1 (assuming /24)
SERVER_NET=$(echo "${wireguard_cidr}" | cut -d'.' -f1-3)
SERVER_IP="$SERVER_NET.1/24"

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
Address = $SERVER_IP
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $DEFAULT_IFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $DEFAULT_IFACE -j MASQUERADE
EOF

# Get public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Public IP: $PUBLIC_IP"

# Generate client configurations
for i in $(seq 1 ${num_clients}); do
  CLIENT_PRIVATE_KEY=$(wg genkey)
  CLIENT_PUBLIC_KEY=$(echo "$CLIENT_PRIVATE_KEY" | wg pubkey)
  CLIENT_IP="10.100.0.$((i + 1))/32"
  
  # Add peer to server config
  cat >> /etc/wireguard/wg0.conf <<EOF

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = $CLIENT_IP
EOF

  # Create client config file
  cat > /root/wg-client-$i.conf <<EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE_KEY
Address = $CLIENT_IP
DNS = 10.0.0.2

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $PUBLIC_IP:51820
AllowedIPs = ${vpc_cidr}
PersistentKeepalive = 25
EOF

  chmod 600 /root/wg-client-$i.conf
  echo "Generated config for client $i"
done

# Start WireGuard
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

echo "WireGuard VPN server setup complete!"
