variable "aws_region" {
  default = "ap-south-1"
}
variable "project_name" {
  default = "guruprasadkaranth"
}
variable "ami_id" {
  description = "AMI ID of existing EC2 instance"
}
variable "key_name" {
  description = "EC2 key pair name"
  default     = ""
}
variable "db_username" {
  description = "RDS master username"
}
variable "db_password" {
  description = "RDS master password"
  sensitive   = true
}
variable "domain_name" {
  default = "guruprasadkaranth.com"
}
