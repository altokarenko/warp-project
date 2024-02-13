aws_region         = "us-west-2"
project_name       = "warp"
account_id         = "851725297717" #<= need set manually
cidr_block         = "10.10"
environment        = "dev"
single_nat_gateway = false
iam_username       = "Terraform" #<- user on whose behalf the infrastructure is being created

#RDS vars
rds_subnet_group_name = "dev"
rds_subnet_group_tags = {
  Name = "dev DB subnet group"
}
rds_allocated_storage     = 10
rds_identifier            = "dev"
rds_storage_type          = "gp2"
rds_engine                = "postgres"
rds_engine_version        = "16.1"
rds_instance_class        = "db.t3.micro"
rds_db_name               = "dev"
final_snapshot_identifier = "dev-rds-final-snapshot"
