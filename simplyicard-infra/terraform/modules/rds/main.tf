
# DB Subnet Group

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "simplyicard-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "simplyicard-rds-subnet-group"
  }
}


# RDS Security Group

resource "aws_security_group" "rds_sg" {
  name        = "simplyicard-rds-sg"
  description = "RDS SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Allow internal VPC traffic
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.vpn_client_cidr_block != "" ? [var.vpn_client_cidr_block] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "simplyicard-rds-sg"
  }
}


# RDS Instance

resource "aws_db_instance" "rds_instance" {
  identifier        = "simplyicard-rds-instance"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true

  tags = {
    Name = "simplyicard-rds-instance"
  }
}
