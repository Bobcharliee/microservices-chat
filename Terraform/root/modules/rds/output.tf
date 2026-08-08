output "rds_endpoint" {
  value = aws_db_instance.ms_db.endpoint
}

output "ms_rds_arn" {
  value = aws_db_instance.ms_db.arn
}

output "ms_rds_id" {
  value = aws_db_instance.ms_db.id
}