resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-alb-security-group"
  description = "${var.project_name}-${var.environment}-alb security group"
  vpc_id      = var.vpc_id


  // Ingress rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP web traffic"
  }

  // Egress rules
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "HTTP internal traffic"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.0"

  name            = "${var.project_name}-${var.environment}-alb"
  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [aws_security_group.this.id]

  target_groups = [
    {
      name_prefix      = "h1"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"
      health_check = {
        path                = "/"
        port                = 80
        protocol            = "HTTP"
        interval            = 30
        timeout             = 10
        healthy_threshold   = 3
        unhealthy_threshold = 3
      }

    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Name      = "${var.project_name}-${var.environment}-alb"
    Terraform = "true"
  }
}
