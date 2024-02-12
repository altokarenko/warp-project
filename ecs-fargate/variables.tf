variable "project_name" {}
variable "environment" {}
variable "private_subnets" {
  type = any
}
variable "ecs_security_group_id" {}
variable "rds_db_host" {}
variable "rds_db_username" {}
variable "rds_db_password" {}
variable "rds_db_name" {}
variable "ecs_cluster_name" {}
variable "ecs_task_execution_role_arn" {}
variable "alb_target_group_arn" {
  type = any
}
variable "warp_image_id" {}
variable "nginx_image_id" {}
