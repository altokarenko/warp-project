resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "ecs_service_role" {
  name = "${var.project_name}-${var.environment}-ecs-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_service_role_policy" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}


resource "aws_security_group" "ecs_security_group" {
  name   = "ecs-security-group"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ecs_security_group.id
  # cidr_ipv4         = var.vpc_cidr_block
  ip_protocol                  = "-1"
  referenced_security_group_id = var.alb_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ecs_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
