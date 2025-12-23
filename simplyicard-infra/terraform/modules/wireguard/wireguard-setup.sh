#!/bin/bash
set -e

# Update system
apt-update && apt-get upgrade -y

# Install WireGuard
apt-get install -y wireguard

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Generate server keys
wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
chmod 600 /etc/wireguard/server_private.key

SERVER_PRIVATE_KEY=$(cat /etc/wireguard/server_private.key)
SERVER_PUBLIC_KEY=$(cat /etc/wireguard/server_public.key)

# Create server configuration
cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
Address = ${wireguard_cidr}
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o ens5 -j MASQUERADE
EOF

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
Endpoint = $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):51820
AllowedIPs = ${vpc_cidr}
PersistentKeepalive = 25
EOF

  chmod 600 /root/wg-client-$i.conf
done

# Start WireGuard
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

echo "WireGuard VPN server setup complete!"
