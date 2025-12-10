output "db_endpoint" {
  description = "The connection endpoint for the database"
  value       = "" # Placeholder until implementation
}

output "db_port" {
  description = "The port the database is listening on"
  value       = 5432 # Placeholder
}

output "db_name" {
  description = "The name of the database"
  value       = var.db_name
}

