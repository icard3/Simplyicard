# TODO: Define RDS resources here
# - aws_db_instance
# - aws_db_subnet_group
# - aws_security_group

#############################################
# RDS Subnet Group (uses private subnets)
#############################################
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.private_subnet_ids}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.private_subnet_ids}-rds-subnet-group"
  }
}

#############################################
# RDS Security Group (for default VPC)
#############################################
resource "aws_security_group" "rds_sg" {
  name        = "${var.private_subnet_ids}-rds-sg"
  description = "Allow RDS MySQL access"
  vpc_id      = var.vpc_id # default VPC ID is passed from root module

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # allow internal VPC traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.private_subnet_ids}-rds-sg"
  }
}

#############################################
# RDS Instance
#############################################
resource "aws_db_instance" "rds_instance" {
  identifier        = "${var.instance_class}-db"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true

  tags = {
    Name = "${var.instance_class}-rds-instance"
  }
}