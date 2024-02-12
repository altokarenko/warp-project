
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.project_name}-${var.environment}-service"
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [var.ecs_security_group_id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn[0]
    container_name   = "nginx"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "${var.project_name}-${var.environment}-task-ecs"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = var.nginx_image_id
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ],
      log_configuration = {
        log_driver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/nginx-task"
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "nginx"
        }
      }
    },
    {
      name      = "warp-demo-wsgi"
      image     = var.warp_image_id
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ],

      environment = [
        {
          name  = "WARP_DATABASE"
          value = "postgresql://${var.rds_db_username}:${var.rds_db_password}@${var.rds_db_host}/${var.rds_db_name}"
        },
        {
          name  = "WARP_DATABASE_INIT_SCRIPT"
          value = "[\"sql/schema.sql\",\"sql/sample_data.sql\"]"
        },
        {
          name  = "WARP_SECRET_KEY"
          value = "mysecretkey"
        },
        {
          name  = "WARP_LANGUAGE_FILE"
          value = "i18n/en.js"
        }
      ],

      mountPoints = [],
      volumesFrom = [],
      log_configuration = {
        log_driver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/warp-task"
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "warp"
        }
      }
    }
  ])
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  tags = {}
}

resource "aws_appautoscaling_target" "dev_to_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "dev_to_memory" {
  name               = "dev-to-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dev_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dev_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dev_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 75
  }
}

resource "aws_appautoscaling_policy" "dev_to_cpu" {
  name               = "dev-to-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dev_to_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dev_to_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dev_to_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 75
  }
}
