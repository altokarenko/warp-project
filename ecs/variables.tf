variable "environment" {}
variable "project_name" {}
variable "aws_region" {}
variable "private_subnets" {
  type = any
}
variable "vpc_cidr_block" {}
variable "vpc_id" {}
variable "alb_security_group_id" {}