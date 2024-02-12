output "alb_target_group_arn" {
  value = module.alb.target_group_arns
}

output "alb_security_group_id" {
  value = aws_security_group.this.id
}
