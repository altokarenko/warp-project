data "aws_ssm_parameter" "rds_username" {
  name = "/${var.environment}/rds_username"
}

data "aws_ssm_parameter" "rds_password" {
  name = "/${var.environment}/rds_password"
}

resource "aws_db_subnet_group" "default" {
  name       = var.rds_subnet_group_name
  subnet_ids = var.private_subnets

  tags = var.rds_subnet_group_tags
}

resource "aws_db_instance" "db" {
  allocated_storage = var.rds_allocated_storage
  identifier        = var.rds_identifier
  storage_type      = var.rds_storage_type
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_class
  db_name           = var.rds_db_name
  username                            = data.aws_ssm_parameter.rds_username.value
  password                            = data.aws_ssm_parameter.rds_password.value
  db_subnet_group_name                = aws_db_subnet_group.default.name
  final_snapshot_identifier           = var.final_snapshot_id
  iam_database_authentication_enabled = true
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

}

resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-db-security-group"
  description = "PSQL security group for ECS"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [5432]
    iterator = port
    content {
      description     = "inbound traffic from ECS"
      from_port       = port.value
      to_port         = port.value
      protocol        = "tcp"
      cidr_blocks     = [var.vpc_cidr_block]
      security_groups = [var.ecs_security_group_id] # ECS to DB
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
