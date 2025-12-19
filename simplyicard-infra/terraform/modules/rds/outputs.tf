output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.rds_instance.endpoint
}

output "db_port" {
  description = "The port the database is listening on"
  value       = 3306
}

output "db_name" {
  description = "The name of the database"
  value       = aws_db_instance.rds_instance.db_name
}

