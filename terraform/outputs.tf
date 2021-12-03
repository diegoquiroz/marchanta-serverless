output "rds_hostname" {
  description = "Postgres hostname"
  value       = aws_db_instance.marchanta.address
  sensitive   = false
}

output "rds_port" {
  description = "Postgres instance port"
  value       = aws_db_instance.marchanta.port
  sensitive   = false
}

output "rds_username" {
  description = "Postgres root username"
  value       = aws_db_instance.marchanta.username
  sensitive   = false
}

output "rds_password" {
  description = "Postgres root pass"
  value       = aws_db_instance.marchanta.password
  sensitive   = true
}
