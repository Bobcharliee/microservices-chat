output "load_balancer_sg_id" {
  value = aws_security_group.load_balancer_sg.id
}

output "app_server_sg_id" {
  value = aws_security_group.app_server_sg.id
}

output "db_server_sg_id" {
  value = aws_security_group.db_server_sg.id
}

output "db_server_sg_name" {
  value = aws_security_group.db_server_sg.name
}