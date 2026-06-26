output "instance_id" { value = aws_instance.main.id }
output "ec2_sg_id"   { value = aws_security_group.ec2.id }
output "public_ip"   { value = aws_instance.main.public_ip }
