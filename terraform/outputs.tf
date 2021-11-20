output "rds_hostname" {
  description = "Postgres hostname"
  value       = aws_db_instance.education.address
  sensitive   = true
}

output "rds_port" {
  description = "Postgres instance port"
  value       = aws_db_instance.education.port
  sensitive   = true
}

output "rds_username" {
  description = "Postgres root username"
  value       = aws_db_instance.education.username
  sensitive   = true
}
