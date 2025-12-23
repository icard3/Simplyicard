output "config_recorder_id" {
  description = "The ID of the config recorder."
  value       = aws_config_configuration_recorder.main.id
}
