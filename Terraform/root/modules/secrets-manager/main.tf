resource "random_password" "password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
}

resource "aws_secretsmanager_secret" "ms_db_secrets" {
  name = "ms_db_secrets"
  recovery_window_in_days = 0

    tags = {
        Name = "ms_db_secrets"
    }
}

# Store the database credentials as a secret
resource "aws_secretsmanager_secret_version" "ms_db_secrets_value" {
  secret_id     = aws_secretsmanager_secret.ms_db_secrets.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.password.result
    })
}