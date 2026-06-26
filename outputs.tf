output "alb_dns_name"     { value = module.alb.alb_dns_name }
output "cloudfront_domain" { value = module.cloudfront_acm.cloudfront_domain }
output "ec2_instance_id"  { value = module.ec2.instance_id }
output "rds_endpoint"     { value = module.rds.rds_endpoint }
