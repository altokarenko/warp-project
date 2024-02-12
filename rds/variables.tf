variable "private_subnets" {
  type = any
}

variable "rds_subnet_group_name" {
  type = string
}
variable "rds_subnet_group_tags" {
  type = map(string)

}
variable "rds_allocated_storage" {
  type = number
}
variable "rds_identifier" {
  type = string
}
variable "rds_storage_type" {
  type = string
}
variable "rds_engine" {
  type = string
}
variable "rds_engine_version" {
  type = string
}
variable "rds_instance_class" {
  type = string
}
variable "rds_db_name" {
  type = string
}
variable "final_snapshot_id" {
  type = string
}
variable "vpc_cidr_block" {}
variable "vpc_id" {}
variable "ecs_security_group_id" {}
variable "project_name" {}
variable "environment" {}