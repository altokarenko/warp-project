data "aws_availability_zones" "this" {}
locals {
  name         = "${var.project_name}-network"
  cluster_name = "${var.project_name}-ecs-cluster"

  tags = {
    Name      = "${var.project_name}-vpc"
    Terraform = "true"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "${var.project_name}-vpc"
  cidr = "${var.cidr_block}.0.0/16"

  azs                        = ["${var.aws_region}b", "${var.aws_region}c", "${var.aws_region}a"]
  private_subnets            = ["${var.cidr_block}.0.0/20", "${var.cidr_block}.16.0/20", "${var.cidr_block}.32.0/20"]
  public_subnets             = ["${var.cidr_block}.128.0/20", "${var.cidr_block}.144.0/20", "${var.cidr_block}.160.0/20"]
  database_subnet_group_name = "${var.project_name}-db"
  enable_dns_support         = true

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    Name                = "${var.environment}-public-subnet"
    "ecs-load-balancer" = "1"
  }
  private_subnet_tags = {
    Name                         = "${var.environment}-private-subnet"
    "ecs-internal-load-balancer" = "1"
  }

  tags = local.tags
}