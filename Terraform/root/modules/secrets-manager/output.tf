output "ms_db_secrets_arn" {
  value = aws_secretsmanager_secret.ms_db_secrets.arn
}

output "ms_db_secrets_name" {
  value = aws_secretsmanager_secret.ms_db_secrets.name
}

output "db_password" {
  value = random_password.password.result
}

