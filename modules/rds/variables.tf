variable "vpc_id" {}
variable "subnet_ids"   { type = list(string) }
variable "ec2_sg_id" {}
variable "db_username" {}
variable "db_password"  { sensitive = true }
variable "project_name" {}
