output "chat_front_ecr_arn" {
    value = aws_ecr_repository.chat_front.arn
}

output "chat_svc_ecr_arn" {
    value = aws_ecr_repository.chat_svc.arn
}

output "chat_db_ecr_arn" {
    value = aws_ecr_repository.chat_db.arn
}
