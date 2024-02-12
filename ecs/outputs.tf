output "ecs_security_group" {
  value = aws_security_group.ecs_security_group.id
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}
