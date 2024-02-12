module "vpc" {
  source             = "../../vpc"
  aws_region         = var.aws_region
  cidr_block         = var.cidr_block
  project_name       = var.project_name
  single_nat_gateway = var.single_nat_gateway
  environment        = var.environment
}

module "ecs" {
  depends_on            = [module.vpc]
  source                = "../../ecs"
  aws_region            = var.aws_region
  environment           = var.environment
  project_name          = var.project_name
  vpc_cidr_block        = module.vpc.vpc_cidr_block
  vpc_id                = module.vpc.vpc_id
  private_subnets       = module.vpc.private_subnets
  alb_security_group_id = module.alb.alb_security_group_id
}

module "ecr" {
  depends_on   = [module.vpc]
  source       = "../../ecr"
  project_name = var.project_name
  environment  = var.environment
}

module "rds" {
  depends_on            = [module.vpc]
  source                = "../../rds"
  environment           = var.environment
  project_name          = var.project_name
  private_subnets       = module.vpc.private_subnets
  rds_subnet_group_name = var.rds_subnet_group_name
  rds_subnet_group_tags = var.rds_subnet_group_tags
  rds_allocated_storage = var.rds_allocated_storage
  rds_identifier        = var.rds_identifier
  rds_storage_type      = var.rds_storage_type
  rds_engine            = var.rds_engine
  rds_engine_version    = var.rds_engine_version
  rds_instance_class    = var.rds_instance_class
  rds_db_name           = var.rds_db_name
  vpc_id                = module.vpc.vpc_id
  ecs_security_group_id = module.ecs.ecs_security_group
  vpc_cidr_block        = module.vpc.vpc_cidr_block
  final_snapshot_id     = var.final_snapshot_identifier
}

module "alb" {
  depends_on            = [module.vpc]
  source                = "../../alb"
  environment           = var.environment
  project_name          = var.project_name
  ecs_security_group_id = module.ecs.ecs_security_group
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  vpc_cidr_block        = module.vpc.vpc_cidr_block
}

module "ecs-service" {
  depends_on                  = [module.rds]
  source                      = "../../ecs-service"
  environment                 = var.environment
  project_name                = var.project_name
  ecs_security_group_id       = module.ecs.ecs_security_group
  ecs_cluster_arn             = module.ecs.ecs_cluster_arn
  private_subnets             = module.vpc.private_subnets
  rds_db_host                 = module.rds.rds_db_host
  rds_db_port                 = module.rds.rds_db_port
  rds_db_username             = module.rds.rds_db_username
  rds_db_password             = module.rds.rds_db_password
  rds_db_name                 = module.rds.rds_db_name
  instance_type               = var.instance_type
  ecs_cluster_name            = module.ecs.ecs_cluster_name
  vpc_id                      = module.vpc.vpc_id
  ecs_task_execution_role_arn = module.ecs.execution_role_arn
  alb_target_group_arn        = module.alb.alb_target_group_arn
}
