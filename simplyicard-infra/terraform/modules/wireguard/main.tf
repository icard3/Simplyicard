data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "wireguard" {
  name        = "wireguard-vpn-sg-v2"
  description = "Security group for WireGuard VPN server"
  vpc_id      = var.vpc_id

  # WireGuard port
  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH for management
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wireguard-vpn-sg"
  }
}

resource "aws_eip" "wireguard" {
  domain = "vpc"
  tags = {
    Name = "wireguard-vpn-eip"
  }
}

resource "aws_eip_association" "wireguard" {
  instance_id   = aws_instance.wireguard.id
  allocation_id = aws_eip.wireguard.id
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "wireguard-ssh-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_instance" "wireguard" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.wireguard.id]
  key_name               = aws_key_pair.ssh.key_name
  user_data_replace_on_change = true
  source_dest_check      = false

  user_data = templatefile("${path.module}/wireguard-setup.sh", {
    vpc_cidr          = var.vpc_cidr
    wireguard_cidr    = var.wireguard_cidr
    num_clients       = var.num_clients
  })

  tags = {
    Name = "wireguard-vpn-server-v2"
  }
}

resource "aws_cloudwatch_metric_alarm" "wireguard_cpu" {
  count               = var.alarm_topic_arn != "" ? 1 : 0
  alarm_name          = "wireguard-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [var.alarm_topic_arn]

  dimensions = {
    InstanceId = aws_instance.wireguard.id
  }
}
