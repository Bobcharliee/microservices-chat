output "target_group_arn" {
  value = aws_lb_target_group.ms-target-group.arn
}

output "load_balancer_arn" {
  value = aws_lb.ms-load-balancer.arn
}
