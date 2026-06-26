resource "aws_security_group" "ec2" {
  name   = "${var.project_name}-ec2-sg"
  vpc_id = var.vpc_id
  ingress { from_port=80;  to_port=80;  protocol="tcp"; security_groups=[var.alb_sg_id] }
  ingress { from_port=443; to_port=443; protocol="tcp"; security_groups=[var.alb_sg_id] }
  ingress { from_port=22;  to_port=22;  protocol="tcp"; cidr_blocks=["0.0.0.0/0"] }
  egress  { from_port=0;   to_port=0;   protocol="-1";  cidr_blocks=["0.0.0.0/0"] }
  tags = { Name = "${var.project_name}-ec2-sg" }
}
resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name               = var.key_name != "" ? var.key_name : null
  tags = { Name = "${var.project_name}-web" }
}
