output "rds_db_host" {
  value = aws_db_instance.db.endpoint
}

output "rds_db_port" {
  value = aws_db_instance.db.port
}

output "rds_db_username" {
  value = aws_db_instance.db.username
}

output "rds_db_password" {
  value = aws_db_instance.db.password
}

output "rds_db_name" {
  value = aws_db_instance.db.db_name
}
